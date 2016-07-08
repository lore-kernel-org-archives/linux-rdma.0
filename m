From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB core sysfs: Add port_xmit_wait_counter V2
Date: Fri, 8 Jul 2016 10:36:06 -0400
Message-ID: <5cb8eb2d-33fa-1f56-661f-615a85875155@dev.mellanox.co.il>
References: <alpine.DEB.2.20.1607071231550.20276@east.gentwo.org>
 <f77b903a-75d5-b7bf-3814-9efa3c627996@dev.mellanox.co.il>
 <alpine.DEB.2.20.1607080911350.3887@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607080911350.3887-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/8/2016 10:12 AM, Christoph Lameter wrote:
> On Fri, 8 Jul 2016, Hal Rosenstock wrote:
> 
>> I'm not following the relationship of _counter field to the offset other
>> than they are combined in the index and then I don't see counter part of
>> index ever being used. So it looks to me like _counter can be
>> deprecated/removed which is what Roland wrote in the thread you
>> referenced below.
> 
> Yup. I think so too. But the rest of the discussion refers to some bit
> that correlates with _counter. There may be something I missed.

Didn't that have to do with set counter ? There is no set counter
support and it seems unlikely to me that it would be added in as this
needs to be done on "manager" and not agent/client side.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
