From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: srp_daemon :    targets      by default
Date: Tue, 9 May 2017 14:41:50 -0400 (EDT)
Message-ID: <475882080.6611379.1494355310585.JavaMail.zimbra@redhat.com>
References: <1494349653.3752.4.camel@profitbricks.com> <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com> <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com> <20170509180159.GK10073@mtr-leonro.local> <1494353077.2518.12.camel@sandisk.com> <20170509182123.GC9715@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170509182123.GC9715-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benjamin drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Jason Gunthorpe" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "benjamin drung"
> <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Sent: Tuesday, May 9, 2017 2:21:23 PM
> Subject: Re: srp_daemon :    targets      by default
> 
> On Tue, May 09, 2017 at 06:04:37PM +0000, Bart Van Assche wrote:
> 
> > Users of large setups know how to edit the srp_daemon configuration file
> > but
> > most users of small setups don't know how to edit that configuration file.
> > So
> > if consistency is required my advice is to change the behavior on Debian to
> > activating all targets by default.
> 
> I thought the default in Debain was to have a null list of devices
> anyhow, so if you just install srp_daemon nothing actually happens
> until the .default config file is edited..
> 
> Thus it seems really strange to have to edit two config files to make
> it work, particularly if there is no security concern here.
> 
> Jason
> 

On Red Hat I have the following default set for the customers I deal with.

# cat srp_daemon.conf
a      queue_size=128,max_cmd_per_lun=32,max_sect=32768


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
