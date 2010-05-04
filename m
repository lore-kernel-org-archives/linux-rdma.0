From: Kumar Vaibhav <kvaibhav-hiIyIPXX6BMxFYw1CcD5bw@public.gmane.org>
Subject: NFS RDMA using autofs
Date: Tue, 04 May 2010 17:13:02 +0530
Message-ID: <4BE00846.70806@barc.gov.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nfs-rdma-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am trying to use NFS-RDMA on RHEL 5u4.

I can mount the exported filesystem manually on the client using

mount.rnfs 190.3.18.185:/scratch/exports /mnt -i -o rdma,port=20049

But the problem I have is that I want it to use it from autofs. So that 
it is mounted based on requirement.

How to make entry corresponfing to this in /etc/auto.master?

Regards,
Vaibhav
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
