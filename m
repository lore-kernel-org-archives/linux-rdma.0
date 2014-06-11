From: Bob Biloxi <iambobbiloxi@gmail.com>
Subject: DMA window vs actual allocatable DMA memory
Date: Wed, 11 Jun 2014 23:53:08 +0530
Message-ID: <CANwwZzVqQ9Dur79ZP_1Fs9UWF0+h44tGW6QA4UZYdXaqV51z3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

I am having trouble understanding DMA window and actual amount of
addressable DMA memory.

I hope someone explains me. Let me put my understanding and doubts here:

Let's say I am writing code for an ethernet device driver in the
virtualisation(hypervisor) environment.

Now, if the ethernet adapter requires certain amount of DMA memory, I
need to allocate heap memory and dma map it and provide to the
adapter.

>From the hardware perspective, we have a 64GB DMA window.

I am having trouble understanding this value. Does it mean i can
allocate 64GB of RAM(Heap memory) and dma map it?

As i understand there might be a table that translates bus address to
physical(RAM) addresses. Each entry of such table points to a 4KB
page. If the size of each entry is 8 bytes and there are 16M such
entries( 16M * 4K = 64GB DMA window), the size of the table comes to
around 128M

Now do I have 64GB DMA memory or 128M DMA memory?

I want to know what is the max amount of memory that I can
allocate(heap), dma map and provide it to the adapter.

I will be really thankful in all the help that I can get!!

Thanks so much


Best Regards,
Marc
