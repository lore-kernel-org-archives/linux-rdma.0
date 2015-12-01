From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: stalled again
Date: Tue, 1 Dec 2015 18:30:28 +0200
Message-ID: <565DCB24.7020304@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

We're against into this... upstream is on 4.4-rc3 while your latest 
branch in kernel.org (the one that carries thefor-next tag) is rebased 
to 4.3-rc3...

--> our internal build and review systems for patches to linux-rdma 
can'tmake any use of your tree. People here have to rebase their work 
against their own clones of Linus tree and can't work with our internal 
Gerrit rdma-next branch, etc, etc.

We have to work in a very inefficient manner.

Any reason on earth not to rebase your tree (== create new branch, move 
their the for-next tag) after an rc1 is out? how long does this take?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
