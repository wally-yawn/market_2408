require './lib/market'
require './lib/vendor'
require './lib/item'

RSpec.describe Market do
    before(:each) do
        @market_1 = Market.new("South Pearl Street Farmers Market")
        @vendor1 = Vendor.new("Rocky Mountain Fresh")
        @vendor2 = Vendor.new("Ba-Nom-a-Nom")  
        @item1 = Item.new({name: 'Peach', price: "$0.75"})
        @item2 = Item.new({name: 'Tomato', price: "$0.50"})
        @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
        @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
        @item5 = Item.new({name: "Plum", price: "$0.25"})
        @vendor1.stock(@item1, 35)
        @vendor1.stock(@item2, 7)
        @vendor2.stock(@item4, 50)
        @vendor2.stock(@item3, 25)
    end

    describe '#initialize' do
        it 'exists' do
            expect(@market_1).to be_an_instance_of(Market)
            expect(@market_1.name).to eq("South Pearl Street Farmers Market")
            expect(@market_1.vendors).to eq([])
        end
    end

    describe '#add vendor' do
        it 'can add a vendor to a market' do
            expect(@market_1.vendors).to eq([])
            @market_1.add_vendor(@vendor1)
            expect(@market_1.vendors.length).to eq(1)
            expect(@market_1.vendors).to eq([@vendor1])
        end

        it 'can add multiple vendors to a market' do
            expect(@market_1.vendors).to eq([])
            @market_1.add_vendor(@vendor1)
            @market_1.add_vendor(@vendor2)
            expect(@market_1.vendors.length).to eq(2)
            expect(@market_1.vendors).to eq([@vendor1, @vendor2])
        end
    end

    describe '#vendor_names' do
        it "can return vendor_names if there are no vendors" do
            expect(@market_1.vendor_names).to eq([])
        end

        it "can return vendor_names if there is one vendor" do
            @market_1.add_vendor(@vendor1)
            expect(@market_1.vendor_names).to eq([@vendor1.name])
        end
        it "can return vendor_names if there are multiple vendors" do
            @market_1.add_vendor(@vendor1)
            @market_1.add_vendor(@vendor2)
            expect(@market_1.vendor_names).to eq([@vendor1.name, @vendor2.name])
        end
    end

    describe '#vendors_that_sell' do
        it 'can return an empty array when there are no vendors' do
            expect(@market_1.vendors_that_sell(@item1)).to eq([])
        end
        it 'can return an empty array when there are are vendors but none sell the item' do
            @market_1.add_vendor(@vendor1)
            expect(@market_1.vendors_that_sell(@item4)).to eq([])
        end
        it 'can return an array of vendors when there are is one vendor' do
            expect(@market_1.vendors_that_sell(@item1)).to eq([])
            @market_1.add_vendor(@vendor1)
            @market_1.add_vendor(@vendor2)
            expect(@market_1.vendors_that_sell(@item1)).to eq([@vendor1])
        end
        it 'can return an array of vendors when there are multiple vendors' do
            expect(@market_1.vendors_that_sell(@item1)).to eq([])
            @market_1.add_vendor(@vendor1)
            @market_1.add_vendor(@vendor2)
            @vendor2.stock(@item1, 10)
            expect(@market_1.vendors_that_sell(@item1)).to eq([@vendor1, @vendor2])
        end
    end

    describe '#sorted_item_list' do
        it 'can return an array if there are no duplicate items' do
            @market_1.add_vendor(@vendor1)
            @market_1.add_vendor(@vendor2)
            expect(@market_1.sorted_item_list).to eq([@item4,@item1,@item3,@item2])
        end
        it 'can return an array if there multiple vendors that sell an item' do
            @market_1.add_vendor(@vendor1)
            @market_1.add_vendor(@vendor2)
            @vendor2.stock(@item1, 5)
            expect(@market_1.sorted_item_list).to eq([@item4,@item1,@item3,@item2])        
        end
    end

    describe '#overstocked items' do
        it 'can return an empty array if there are no overstocked items' do
            @market_1.add_vendor(@vendor1)
            @market_1.add_vendor(@vendor2)
            expect(@market_1.overstocked_items).to eq([])
        end
        it 'can return an array if there are multiple overstocked items by one seller' do
            @market_1.add_vendor(@vendor1)
            @market_1.add_vendor(@vendor2)
            expect(@market_1.overstocked_items).to eq([])
            @vendor1.stock(@item5, 55)
            expect(@market_1.overstocked_items).to eq([@item5])
        end
        it 'can return an array if there are multiple overstocked items by two sellers' do
            @market_1.add_vendor(@vendor1)
            @market_1.add_vendor(@vendor2)
            expect(@market_1.overstocked_items).to eq([])
            @vendor1.stock(@item5, 55)
            @vendor2.stock(@item1, 25)
            expect(@market_1.overstocked_items).to eq([@item1,@item5])
        end
    end
end