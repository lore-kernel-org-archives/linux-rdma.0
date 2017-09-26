From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5:: pr_err() and mlx5_ib_dbg() strings should end
 with newlines
Date: Tue, 26 Sep 2017 08:05:37 -0700
Message-ID: <1506438337.29089.8.camel@perches.com>
References: <7a5a195cd37db476a2ca007eddc0f28f3ade265b.1506407876.git.arvind.yadav.cs@gmail.com>
         <20170926083843.GB6816@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926083843.GB6816-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-26 at 11:38 +0300, Leon Romanovsky wrote:
> On Tue, Sep 26, 2017 at 12:20:01PM +0530, Arvind Yadav wrote:
> > pr_err() and mlx5_ib_dbg( messages should terminated with a new-line to
> > avoid other messages being concatenated.
[]
> Did you see it is happening?
> It is not needed after 4bcc595ccd80 ("printk: reinstate KERN_CONT for printing continuation lines")

Not completely true, and that commit message
itself is incorrect about how KERN_CONT was
ever required or not required.

After that commit, the dmesg output will
eventually be corrected with an appended newline
for sine line format strings without them, but
the printk subsystem has to wait for another
printk to occur before inserting that newline.

The commit message bit that says:

    Things get much hairier when you have
    multiple threads going on and user level
    reading and writing logs too

is correct.  That's the actual reason that
the proposed newline additions are reasonable.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
