From: Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: =?Windows-1252?Q?[RFC]_=96_Proposal_for_new_process_for_OFED_releases?=
Date: Thu, 1 Dec 2011 19:53:28 +0000
Message-ID: <CD250C48050CFB4D95E78C95F2FDDD6E237661EA@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


We propose a new process for the OFED releases starting from next OFED release:
- OFED content will be the relevant kernel.org modules and user space released packages
- OFED will offer only backports to the distros  (no fixes)
- OFED package will be used for easy installation of all packages in a friendly manner

The main goals of this change:
1. Ensure OFED and the upstream kernel are the same
2. Provide customers a way to use the new features in latest kernels on existing distros
3. OFED qualification will contribute to the stability of the upstream code 
 
We think that at this point of the RDMA technology maturity this is the right way to go.
In this way OFED is not conflicting with the kernel or the distros, and still provide a valuable value for early adopters of new features.

Versions:
We suggest that the OFED version will be the same as kernel.org
For example, for kernel 3.2 the OFED release would be OFED-3.2. 
This would make it easy for people to associate the OFED code with the corresponding kernel.org code.

Some open questions that we should consider:
- How to handle experimental features?
- Need to follow up kernel stable releases if bug fixes are relevant to OFA modules
- Should we have a release for every kernel release (I think yes)
- What should we do with modules like SDP that are not in kernel?

Comments and responses are welcome
The decision will be taken in the next EWG meeting.

Tziporet & Woody

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
