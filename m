From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Tue, 10 Oct 2017 11:13:22 -0400
Message-ID: <1507648402.46071.53.camel@redhat.com>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
         <20171006214243.11296-4-bart.vanassche@wdc.com>
         <20171008100317.GR25829@mtr-leonro.local>
         <1507568205.46071.46.camel@redhat.com> <1507568492.2674.11.camel@wdc.com>
         <20171010041423.GJ1252@mtr-leonro.local>
         <9443ec1f-0acd-9fa3-4621-a29085d2c606@redhat.com>
         <20171010150018.GC2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171010150018.GC2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-10 at 18:00 +0300, Leon Romanovsky wrote:
> On Tue, Oct 10, 2017 at 10:34:19AM -0400, Doug Ledford wrote:
> > On 10/10/2017 12:14 AM, Leon Romanovsky wrote:
> > > 
> Doug,
> But my question was "when" and not "how". When should I set this
> parameter to true?

Whenever you want.  When do you set the maximum TCP window size to 4MB?
 If you have an issue with things being one way, you try another. 
Things like this are system specific and often there is no universal
answer, especially since the answer here could very easily depend on
things like how many targets you are connecting to, how fast those
targets are, etc.

> > 
> > > In the commit message, you mentioned disadvantages of using SRQ
> > > is a
> > > default and among them - locks contention, which can be changed
> > > in the
> > > future. Won't it mean that users stuck with current default,
> > > because
> > > change of default will "break" their scripts?
> > 
> > No, it won't.  If you change the default, you don't remove the
> > variable,
> > you just change what its setting is.  Then existing modprobe.d
> > files
> > become redundant, but nothing breaks.  People that don't want the
> > new
> > setting add a new file to the modprobe.d directory to change the
> > option.
> 
> Not accurate, now I won't set any parameter because I'm relying on
> the
> fact that the default is without SRQ. Once the default will be
> changed,
> it will break my assumption.

So?  Your assumptions are never a reason to prevent ongoing
development.  By this argument, we would never have been able to turn
on SCSI Multi-queue by default because when it was first added to the
kernel it was off by default and people might have made an assumption
that we would later break when we turned it on by default.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
