From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCHv2 rdma-core 1/2] srp_daemon: handle SM lid change
Date: Fri, 15 Dec 2017 10:33:08 -0700
Message-ID: <20171215173308.GB12434@ziepe.ca>
References: <001cdcfd-8ace-261f-ab86-a09ae3582dd8@suse.com>
 <be797b2f-0317-f9ac-d0ec-5284632790b9@suse.com>
 <a4b3d5e1-f611-9305-1ed2-d4a51ebe4611@intel.com>
 <5c12ee61-22f3-239d-8fbb-59c381b8ce13@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5c12ee61-22f3-239d-8fbb-59c381b8ce13-IBi9RG/b67k@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 15, 2017 at 01:41:12PM +0100, Nicolas Morey-Chaisemartin wrote:

> I used this command  to generate the line
> $ git  log -n1 --pretty='%h (%s)' 4952e5f7df0c93d6f3972975106c5e06623a301d
> 4952e5f7 (Fix a memory leak)
> 
> Isn't the abbreviated hash supposed to be enough ?

You can put this alias in your .gitconfig to generate teh correct
format:

[alias]
        fixes = log --abbrev=12 -1 --format='Fixes: %h (\"%s\")'


And your git is older so you need to add

[core]
	abbrev = 12

To your config too.

The 8 character abbrev is known to have collisions already for
linux-kernel (but probably not in rdma-core)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
