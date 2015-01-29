From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and multicast
 traffic
Date: Thu, 29 Jan 2015 14:51:44 +0200
Message-ID: <54CA2CE0.30107@mellanox.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
		 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
		 <1422301106.2854.41.camel@redhat.com>
		 <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com>
	 <1422309605.2854.62.camel@redhat.com> <54C74D49.3080201@dev.mellanox.co.il>
 <1422378130.2854.119.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422378130.2854.119.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/27/2015 7:02 PM, Doug Ledford wrote:
> [...]
> I haven't heard an argument from you yet that I believe beats the points
> I've made above.  So I believe a solution that does not revert back to
> having two separate code paths to be maintained is preferable to your patch.

Doug,

It's not going to work this way.

We should 1st and most take a decision what gonna happen with the 
3.19driver
and only then restart/resume the multi way/arguments discussion, and we 
have
very little time for 3.20-rc1too, BTW.

So lets close the 3.19 saga, again, either revert your eight patches or 
apply Erez's patch.

This way or another for 3.20 we can do things right by whatever method 
we agree on.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
