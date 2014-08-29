From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: Re: mlx4 query in sriov mode
Date: Fri, 29 Aug 2014 12:21:21 +0800
Message-ID: <20140829042121.GA31486@richard>
References: <CANwwZzXowyGmg-cfCHQqeJ_iqjT+Ec+JPy+OWzNGeyN=hRqmPg@mail.gmail.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANwwZzXowyGmg-cfCHQqeJ_iqjT+Ec+JPy+OWzNGeyN=hRqmPg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bob Biloxi <iambobbiloxi@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 28, 2014 at 10:58:50PM +0530, Bob Biloxi wrote:
>Hi All,
>
>
>I really appreciate this wonderful community which has immensely
>helped me broaden my knowledge and understanding.
>
>
>I was going through the mlx4 sriov code, trying to understand the
>communication between the VF driver and the PF driver.
>
>I was having a few queries..hoping to get a better understanding.
>
>
>As I understand, the commands are communicated between VF and PF
>through a mechanism called communication channel. VF writes to
>specific address in its BAR space, PF gets an event and then proceeds
>ahead to read the command from its BAR space and then complete the
>execution of it..
>
>
>Now, my query is, lets say the VF driver is not yet present and only
>the PF driver is there...
>
>In this case, can we simulate a VF command write and get notified
>through an event?
>

Hi,

I am not that familiar with mlx4 driver. As you mentioned in previous, VF
communicate with PF by writing some word in BAR and PF gets it. If this is
true, I believe it would works.

>For eg. we write to some offset in the PF BAR space itself upon
>completion of which, an event is generated because of the write? kind
>of like loopback mechanism.
>
>
>I searched through the code but couldn't find anywhere.
>
>Can anyone please help me understand if this is possible? And if there
>is any location in the code where i can find this?

Where you fund the communication between PF and VF is by writing its BAR?

>
>Thanks a lot in advance!!
>
>
>Best Regards,
>Bob
>--
>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Richard Yang
Help you, Help me
