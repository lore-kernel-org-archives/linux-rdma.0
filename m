From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/4] arbitrary sg lists support
Date: Thu, 13 Apr 2017 12:59:32 -0400 (EDT)
Message-ID: <367807838.15062382.1492102772337.JavaMail.zimbra@redhat.com>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com> <1492101079.5176.9.camel@sandisk.com> <9a8bc957-dcc0-2e54-d631-9f05f96e0f18@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9a8bc957-dcc0-2e54-d631-9f05f96e0f18-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, "keith busch" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
> linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Sent: Thursday, April 13, 2017 12:46:27 PM
> Subject: Re: [PATCH v2 0/4] arbitrary sg lists support
> 
> 
> 
> On 4/13/2017 7:31 PM, Bart Van Assche wrote:
> > On Thu, 2017-04-13 at 18:56 +0300, Max Gurtovoy wrote:
> >> This patch adds an arbitrary sg list support to NVMEoF host for
> >> capable devices (such as RDMA CX4/CX5 HCAs).
> >> During the review we decided to add an helper function to ib_core
> >> that will be used by ULPs in order to avoid code duplication.
> >
> > Hello Max,
> >
> > A question that is not related to the ULP drivers touched by this patch
> > series:
> > some time ago registration of sg-lists with gaps was disabled in the SRP
> > initiator because arbitrary sg-lists triggered CQE dumps in combination
> > with the
> > mlx5 driver. Does this mean that this issue has been resolved? If so, what
> > mlx5
> > driver and/or firmware version are needed to reenable arbitrary sg-list
> > support
> > in the SRP initiator?
> >
> 
> Hi Bart,
> IsraelR and I couldn't repro this issue even once on our labs. I suggest
> we take it with Laurence and try to figure it out.
> I can try installing the latest FW on CX4/5 cards in Laurence Lab and
> run the test suite again.
> 
> > Thanks,
> >
> > Bart.
> >
> 

Hello 
That's fine.

Lab is always ready for the SRP tests, I keep it that way.
The lab has mlx5 back-to-back iwth opensm and EDR100

Regards
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
