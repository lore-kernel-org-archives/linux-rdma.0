From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: =?UTF-8?Q?Re:_srp=5fdaemon_:_=e2=80=8bDisallow_=e2=80=8ball_targets?=
 =?UTF-8?B?IOKAi2lmIOKAi25vdCDigItleHBsaWNpdGx5IOKAi2FsbG93ZWQgYnkgZGVmYXVs?=
 =?UTF-8?Q?t?=
Date: Tue, 9 May 2017 10:11:06 -0700
Message-ID: <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
References: <1494349653.3752.4.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494349653.3752.4.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/09/17 10:07, Benjamin Drung wrote:
> srptools 1.0.3-2 in Debian disallows all targets if not explicitly
> allowed by default. Motivation (taken from debian/changelog):
> 
> * Don't activate any targets per default. (Closes: #740945)
>   This is more sensible than the previous default of bringing
>   up all targets in the IB fabric upon boot. In a larger fabric
>   with many storage targets available, most of the times only
>   one or a few targets are wanted on a particular machine.
> 
> Do you agree and could you change the default upstream? I prefer not to
> carry a different behavior in Debian alone.

Hello Benjamin,

What I expect is that users will hate this change. They will notice that
after they have installed and enabled srp_daemon that no targets are
discovered without having any clue why no automatic login to SRP targets
occurs.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
