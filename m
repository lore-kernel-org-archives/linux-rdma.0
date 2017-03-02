From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 16/20] IB/hfi1: Add receive fault injection feature
Date: Thu, 2 Mar 2017 12:19:58 -0500
Message-ID: <3d0824e9-38c6-b0e3-9c31-db47ba6c5522@intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
 <20170301182344.29989.12032.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301182344.29989.12032.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/01/2017 01:23 PM, Dennis Dalessandro wrote:
> +static int __init fault_init_opcode_debugfs(struct hfi1_ibdev *ibd)
> +{

Turns out gcc 4.4 doesn't like the __init annotation. After getting all 
clear email from 0-day builds I got another WARNING email later on that 
night. Compiles cleanly on more recent gcc but we might as well go ahead 
and fix as this seems to be a deprecated practice anyway. Will follow up 
with an updated patch shortly.

> +static int __init fault_init_packet_debugfs(struct hfi1_ibdev *ibd)

And this one.

> +static int __init fault_init_debugfs(struct hfi1_ibdev *ibd)

And one more.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
