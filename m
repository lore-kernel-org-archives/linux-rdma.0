From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix unneeded return error in eth_link_query_port
Date: Mon, 25 Oct 2010 11:33:11 +0200
Message-ID: <4CC54ED7.6030303@Voltaire.com>
References: <20101024075835.GA11359@mtldesk30> <adahbgbppgx.fsf@cisco.com>	<20101024160018.GA32499@mtldesk30> <adaocajo90s.fsf@cisco.com>	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com> <4CC54D4E.7050203@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC54D4E.7050203-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I pulled/built/booted with the for-next branch of Roland's tree, and I can't get IB link for the node, 
> I don't think this is my problem, since I'm on L2 IB and not Eth, but should this work with pre 2.7 
> firmware?! if not, maybe patch the mlx4 driver to print some error,

Oh, I also see an error printed by some script provided by the RHEL5 libmlx4 package, 

> # modprobe mlx4_ib
> awk: /etc/ofed/setup-mlx4.awk:6: (FILENAME=/etc/ofed/mlx4.conf FNR=21) fatal: cannot open file `/sbin/setup-mlx4' for reading (No such file or directory)

> # rpm -qf /etc/ofed/setup-mlx4.awk
> libmlx4-1.0.1-5.el5


> # rpm -ql libmlx4-1.0.1-5.el5
> /etc/libibverbs.d/mlx4.driver
> /etc/modprobe.d/libmlx4.conf
> /etc/ofed/mlx4.conf
> /etc/ofed/setup-mlx4.awk
> /usr/lib64/libmlx4-rdmav2.so
> /usr/lib64/libmlx4.so
> /usr/share/doc/libmlx4-1.0.1
> /usr/share/doc/libmlx4-1.0.1/AUTHORS
> /usr/share/doc/libmlx4-1.0.1/COPYING
> /usr/share/doc/libmlx4-1.0.1/README
> /etc/libibverbs.d/mlx4.driver
> /etc/modprobe.d/libmlx4.conf
> /etc/ofed/mlx4.conf
> /etc/ofed/setup-mlx4.awk
> /usr/lib/libmlx4-rdmav2.so
> /usr/lib/libmlx4.so
> /usr/share/doc/libmlx4-1.0.1
> /usr/share/doc/libmlx4-1.0.1/AUTHORS
> /usr/share/doc/libmlx4-1.0.1/COPYING
> /usr/share/doc/libmlx4-1.0.1/README
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
