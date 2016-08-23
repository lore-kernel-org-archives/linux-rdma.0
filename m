From: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.7.0 ib_srpt Regression - 4.6.4 Got failed path rec status -22
 got worse on 4.7.0
Date: Tue, 23 Aug 2016 04:53:21 -0400
Message-ID: <CA+X5Wn6zJp2nGUF2TNjtY28gG8-Ho-yyO2a49JUm2ph0qJ7zDQ@mail.gmail.com>
References: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA@mail.gmail.com>
 <39412892-aab7-5bf9-7a19-be311dc32050@sandisk.com> <CA+X5Wn7KbG-6Hg2JdOJhteXezgMS5O6DkixOjB3idoWu=UXKJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn7KbG-6Hg2JdOJhteXezgMS5O6DkixOjB3idoWu=UXKJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I made a bad assumption.  Turns out if the target is on 4.7.0, I can't
use SRP under an circumstances - even with the initiator booted from a
hard drive.

So, the 4.7.0 issue is separate than the 4.6.4 10-30 second delay from
linux trying to make its own SRP connection while the iPXE SRP
connection is still up.

After I upgraded my target to 4.7.0, the first thing I tested was SRP
booting, and when I saw it fail, I didn't ever test if my hard drive
installed initiator could still use SRP.  I just reverted target back
to 4.6.4.

Doing a git bisect now.  (Stumbled into my bad assumption using SRP
volumes for the kernel bisect, while target happened to be 4.7.0!)

Have it narrowed down between commits

(good)
9903fd1 - Thu Jun 23 12:22:33 2016 -0400 - Doug Ledford : Merge
branches '4.7-rc-misc', 'hfi1-fixes', 'i40iw-rc-fixes' and
'mellanox-rc-fixes' into k.o/for-4.7-rc

(bad)
30f56e3 - Tue Jul 19 16:44:11 2016 -0700 - Eugenia Emantayev :
net/mlx4_en: Move filters cleanup to a proper location

Reverting 30f56e3 doesnt' fix it.

There's no comits between there to
drivers/infiniband/{core/sq_query.c, hw/mlx4/, ulp/srp, ulp/srpt} or
drivers/net/mellanox/mlx4, so it will be interesting to see what's
causing it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
