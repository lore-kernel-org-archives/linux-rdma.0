From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: some dapl assistance
Date: Thu, 15 Jul 2010 11:16:22 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983010458EEEF@orsmsx506.amr.corp.intel.com>
References: <4C344493.2030600@Voltaire.com><E3280858FA94444CA49D2BA02341C983010435A1A8@orsmsx506.amr.corp.intel.com><4C3C50CC.7000508@Voltaire.com><E3280858FA94444CA49D2BA02341C9830104493030@orsmsx506.amr.corp.intel.com><6D1AA8ED7402FF49AFAB26F0C948ACF5014B9894@exil.voltaire.com>
 <E3280858FA94444CA49D2BA02341C983010458ECD5@orsmsx506.amr.corp.intel.com>
 <6D1AA8ED7402FF49AFAB26F0C948ACF5014B98F3@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6D1AA8ED7402FF49AFAB26F0C948ACF5014B98F3-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Itay Berman <itayb-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
>No:
>No. Same warning:
>
>dodly4:625b:  Warning: new pkey(32770), query (Success) err or 
>key !found, using defaults
>dodly4:625b:  query_hca: port.link_layer = 0x1
>dodly4:625b:  query_hca: (a0.0) eps 262076, sz 16351 evds 
>65408, sz 4194303 mtu 2048 - pkey 32770 p_idx 0 sl 0
>
>[root@dodly0 compat-dapl-1.2.18]# cat 
>/sys/class/infiniband/mthca0/ports/1/pkeys/1
>0x8002

Sorry, I only have mlx4 adapters. 
Can you check ibv_devinfo -v and look for max_pkeys?

Thanks,

-arlin



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
