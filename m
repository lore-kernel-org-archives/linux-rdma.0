From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: how to preserve QP over HA events for librdmacm applications
Date: Wed, 19 Sep 2012 14:14:59 -0400
Message-ID: <86756672-ADCC-4EF0-A24C-19C4A0EB8188@ornl.gov>
References: <5059E82E.9020600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8E418@ORSMSX101.amr.corp.intel.com>
 <5059EA48.1040407@mellanox.com>
 <A4E971F4031F1840BBA6E79B417E62E82CF29C3B@MTRDAG01.mtl.com>
 <46C75A5F-AD9F-45CF-A441-B7D5F60709D8@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A8237346A8E47E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8E47E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sep 19, 2012, at 1:05 PM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> I too would be interested in bringing a QP from error back to a usable state. I
>> have been debating whether to reconnect using the current RDMA calls versus
>> trying to transition the existing RC QP.
>> 
>> I assumed to transition the existing QP that I would need to open a socket to
>> coordinate the two sides. Is that correct?
>> 
>> If I were instead to use rdma_connect(), does it require a new CM id or just a
>> new QP within the same id?
> 
> What do you gain by transitioning an RC QP from error to RTS, versus just establishing a new connection?

I have a certain amount of state regarding a peer. I lookup that state based on the qp_num returned within a work completion, for example. If I reconnect, I will need to migrate the state from the old qp_num to the new qp_num.

I have no preference which is why I asked about the two options (opening a socket to coordinate state transitions versus connecting with a new QP).

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
