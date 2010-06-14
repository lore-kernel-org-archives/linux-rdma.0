From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [ewg] [PATCH] node description patch
Date: Mon, 14 Jun 2010 08:05:10 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D0A28F7F@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D73B@MNEXMB1.qlogic.org>,<4C15DD8A.3010806@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C15DD8A.3010806-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or, 

Thanks. I'll prep the updated script.
________________________________________
From: Or Gerlitz [ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org]
Sent: Monday, June 14, 2010 2:43 AM
To: Mike Heinz
Cc: Jack Morgenstein; linux-rdma
Subject: Re: [ewg] [PATCH] node description patch

Mike Heinz wrote:
> This patch fixes a problem with the openibd initialization script.
> On machines using slower DHCP servers, openibd frequently sets the HCA's node description
> to HCA-1. This patch modifies openibd to add a "@" instead of the hostname and adds a
> small hook in the core drivers to replace the "@" sign with the system's utsname().
> Because this patch depends on changes to openibd, it cannot be submitted
> to the upstream kernel, but it still corrects an outstanding issue with OFED

Mike,

The fact that you patch is both to user and kernel space code doesn't mean the kernel part can't be submitted upstream. I suggested you re post the patches to linux-rdma in a series made of two patches, one to the kernel and one to the service script. The kernel part then could be picked by the maintainer and will come into play once there's user space code plugging to it. This is similar to cases where people have kernel netlink agent code, merging is not dependent on the existence of specific matching user space code.

As for the user space part, the IB stack provided by the distros does have a service script and this service script attempts to set the node descriptor, e.g here's the RHEL6 beta rdma service code

> # grep -A 13 "node description" /etc/rc.d/init.d/rdma
>     # Add node description to sysfs
>     IBSYSDIR="/sys/class/infiniband"
>     if [ -d ${IBSYSDIR} ]; then
>         declare -i hca_id=1
>         for hca in ${IBSYSDIR}/*
>         do
>             if [ -w ${hca}/node_desc ]; then
>                 echo -n "$(hostname | cut -f 1 -d .) HCA-${hca_id}" >> ${hca}/node_desc 2> /dev/null
>             fi
>             let hca_id++
>         done
>     fi
>
>     errata_58

If you want to patch this, you can here open a bugzilla case with the relevant distro and propose a patch.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
