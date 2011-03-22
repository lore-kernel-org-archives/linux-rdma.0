From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: cancel pending LAP message
Date: Tue, 22 Mar 2011 10:38:30 +0200
Message-ID: <4D886006.4090605@mellanox.com>
References: <1300212118-12602-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300212118-12602-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> Linus, please pull from
>     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
> This will get the first batch of 2.6.39 changes:
> Sean Hefty (4):
>       IB/cm: Cancel pending LAP message when exiting IB_CM_ESTABLISH state

Hi Moni, Amir, please note that a patch fixing the issue you reported on 
  was merged upstream @ commit 8d8ac86564b616bc17054cbb6e727588da64c86b
"IB/cm: Cancel pending LAP message when exiting IB_CM_ESTABLISH stat"
I think you mentioned that there were more cases potentially not covered
by this patch which you wanted to fix as well.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
