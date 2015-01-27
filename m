From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and multicast
 traffic
Date: Tue, 27 Jan 2015 15:05:58 +0200
Message-ID: <54C78D36.7050700@mellanox.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
	 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
	 <1422301106.2854.41.camel@redhat.com>
	 <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com>
 <1422309605.2854.62.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422309605.2854.62.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/27/2015 12:00 AM, Doug Ledford wrote:
> However, I didn't get more than 5 minutes into testing before I was able
> to livelock the system.  In this case, from machine A running my
> patchset, I did
>
> ping6 -I mlx4_ib0 -i .25 <machine B address>
>
> On machine B running Erez's patch, I did:
>
> rmmod ib_ipoib; modprobe ib_ipoib mcast_debug_level=1; sleep 2; ping6
> -i .25 -c 10 -I mlx4_ib0 <machine A address>
>
> And on the machine rdma-master, where the opensm runs, I did just a few:
>
> systemctl restart opensm
>
> The livelock is in the mcast flushing code.  On the machine that livelocked

Doug,

The tests you are running and the issues you are seeing fall well into a 
to-be-fixed-in-some-kernel-rc1 category but by NO means as something 
which should be an rc6 fix.

You must do the distinction between Erez's patch that fixes the 
regressions introduced on 3.19-rc1 to your attempts to fix many more 
instabilities in the IPoIB driver, which are seen under whatever nasty 
test you are running (and it's good we want to reach there).

Roland, the V3 patch solves the rc1 regression and I think we should 
pick it up, by no way we can allow to pick eleven patches @ this point.

Thoughts?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
