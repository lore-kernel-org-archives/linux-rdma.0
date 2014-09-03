From: Bob Biloxi <iambobbiloxi@gmail.com>
Subject: Re: mlx4 query in sriov mode
Date: Wed, 3 Sep 2014 11:45:03 +0530
Message-ID: <CANwwZzW5L7-L-PW4b+a4VSwqHTYfBL2kpB20mRjvVcjJiiOqUQ@mail.gmail.com>
References: <CANwwZzXowyGmg-cfCHQqeJ_iqjT+Ec+JPy+OWzNGeyN=hRqmPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CANwwZzXowyGmg-cfCHQqeJ_iqjT+Ec+JPy+OWzNGeyN=hRqmPg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Can anyone from Mellanox please help me understand this better? really
hoping for any pointers that will be helpful...

Specifically:

> Now, my query is, lets say the VF driver is not yet present and only
> the PF driver is there...
>
> In this case, can we simulate a VF command write and get notified
> through an event?
>
> For eg. we write to some offset in the PF BAR space itself upon
> completion of which, an event is generated because of the write? kind
> of like loopback mechanism.
>


Thanks so much,
Bob

On Thu, Aug 28, 2014 at 10:58 PM, Bob Biloxi <iambobbiloxi@gmail.com> wrote:
> Hi All,
>
>
> I really appreciate this wonderful community which has immensely
> helped me broaden my knowledge and understanding.
>
>
> I was going through the mlx4 sriov code, trying to understand the
> communication between the VF driver and the PF driver.
>
> I was having a few queries..hoping to get a better understanding.
>
>
> As I understand, the commands are communicated between VF and PF
> through a mechanism called communication channel. VF writes to
> specific address in its BAR space, PF gets an event and then proceeds
> ahead to read the command from its BAR space and then complete the
> execution of it..
>
>
> Now, my query is, lets say the VF driver is not yet present and only
> the PF driver is there...
>
> In this case, can we simulate a VF command write and get notified
> through an event?
>
> For eg. we write to some offset in the PF BAR space itself upon
> completion of which, an event is generated because of the write? kind
> of like loopback mechanism.
>
>
> I searched through the code but couldn't find anywhere.
>
> Can anyone please help me understand if this is possible? And if there
> is any location in the code where i can find this?
>
> Thanks a lot in advance!!
>
>
> Best Regards,
> Bob
