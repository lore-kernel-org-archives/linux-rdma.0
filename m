From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/mlx4: Fix max_wqe capacity report for query device
Date: Mon, 28 May 2012 07:14:20 +0300
Message-ID: <4FC2FB9C.1070306@mellanox.com>
References: <1337864889-20886-1-git-send-email-ogerlitz@mellanox.com> <1337864889-20886-3-git-send-email-ogerlitz@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237346A23DD0@ORSMSX101.amr.corp.intel.com> <CAJZOPZLvNHXkY9zakzVJqxYo1n=RYyRdpL6fVpchvo2GcmRLZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLvNHXkY9zakzVJqxYo1n=RYyRdpL6fVpchvo2GcmRLZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/25/2012 6:04 AM, Or Gerlitz wrote:
>> I don't understand the part about breaking the ABI.  Why wouldn't you just
>> return the correct values from the kernel?  Are the values being returned now usable?
>
> Addressing the 2nd part of your question, the patch makes sure that
> the values returned now are usable for kernel consumers, as for user
> consumers, that's work in done in the patches I just sent to libmlx4.

Sean,

Did you try out the patches? was it helpful to address the problem 
you're facing?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
