From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/8] srp_daemon: Add a --systemd option
Date: Fri, 28 Jul 2017 12:35:07 +0200
Message-ID: <1501238107.4572.39.camel@profitbricks.com>
References: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1501099152-6344-4-git-send-email-jgunthorpe@obsidianresearch.com>
         <1501164749.4572.30.camel@profitbricks.com>
         <20170727164851.GB13245@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170727164851.GB13245-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Donnerstag, den 27.07.2017, 10:48 -0600 schrieb Jason Gunthorpe:
> On Thu, Jul 27, 2017 at 04:12:29PM +0200, Benjamin Drung wrote:
> > Am Mittwoch, den 26.07.2017, 13:59 -0600 schrieb Jason Gunthorpe:
> > > This changes how logging is setup to send log messages only to
> > > syslog,
> > > instead of to stderr and to syslog. If messages are sent to both
> > > places then systemd will create duplicate log entries.
> > 
> > The parameter name --systemd is not a good choice. It doesn't tell
> > me what will change ("Enable systemd integration" does not help
> > here) and someone might to want to use the switch without
> > systemd. So something like --no-log-to-stderr or --syslog-only
> > would
> > better describe the behavior.
> 
> There are more systemd integration features to come, eg sd_notify,
> some journal integration is possible.
> 
> I don't want to keep adding options along these lines, universally
> having --systemd to turn everything we want to do on makes sense.

A more flexible approach: Add individual parameters and let the
--systemd parameter just be an alias for these. So the man page would
say: "--systemd is equivalent to --foo --bar --baz"

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
