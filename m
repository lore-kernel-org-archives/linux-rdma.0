From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: kernel space iWARP broken with CONFIG_SECURITY_INFINIBAND enabled
Date: Wed, 15 Nov 2017 18:45:26 +0530
Message-ID: <20171115131525.GB25574@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-XVmvHMARGATQT0dZR+AlfA@public.gmane.org, danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,
With CONFIG_SECURITY_INFINIBAND kernel config option enabled iWARP kernel 
space applications are failing at rdma_create_qp(). Apparantly SELinux 
support for Infiniband RDMA caused this regression.

Here is the failure with NVMEof discovery:
[  129.294943] nvme nvme0: rdma_resolve_addr wait failed (-22).

Failure is at ib_get_cached_pkey(), for invalid pkey_index, called by the 
following call chain: 
rdma_create_qp()-> cma_init_conn_qp()-> ib_modify_qp()-> 
ib_security_modify_qp()-> check_qp_port_pkey_settings()-> 
get_pkey_and_subnet_prefix()

SELinux support for Infiniband RDMA:
https://www.spinics.net/lists/linux-rdma/msg38705.html

I am trying to understand how IB security enforcing works with iWARP. 
>From the commit messages these appears to be an IB specific changes.
If true, how is iw_cm supposed to handle it?
iWARP doesn't use or have partition keys (pkey), How is this handled by the 
IB security enforcing changes?

Thanks,
Bharat.
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
