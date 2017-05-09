From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: =?utf-8?Q?Re:_srp=5Fdaemon_:_=E2=80=8BDisallow_=E2=80=8Ball_targets_?=
 =?utf-8?Q?=E2=80=8Bif_=E2=80=8Bnot_=E2=80=8Bexplicitly?=
 =?utf-8?Q?_=E2=80=8Ballowed_by_default?=
Date: Tue, 9 May 2017 13:41:46 -0400 (EDT)
Message-ID: <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
References: <1494349653.3752.4.camel@profitbricks.com> <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <021b0a17-0552-6ee4-ec19-0e86ead527ef-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Benjamin Drung" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, May 9, 2017 1:11:06 PM
> Subject: Re: srp_daemon : ​Disallow ​all targets ​if ​not ​explicitly ​allowed by default
> 
> On 05/09/17 10:07, Benjamin Drung wrote:
> > srptools 1.0.3-2 in Debian disallows all targets if not explicitly
> > allowed by default. Motivation (taken from debian/changelog):
> > 
> > * Don't activate any targets per default. (Closes: #740945)
> >   This is more sensible than the previous default of bringing
> >   up all targets in the IB fabric upon boot. In a larger fabric
> >   with many storage targets available, most of the times only
> >   one or a few targets are wanted on a particular machine.
> > 
> > Do you agree and could you change the default upstream? I prefer not to
> > carry a different behavior in Debian alone.
> 
> Hello Benjamin,
> 
> What I expect is that users will hate this change. They will notice that
> after they have installed and enabled srp_daemon that no targets are
> discovered without having any clue why no automatic login to SRP targets
> occurs.
> 
> Bart.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello

Indeed, I agree with Bart here, this change will lead to a lot of confusion about why users no longer see device discovery.
For me I would prefer its not changed.

Regards
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
