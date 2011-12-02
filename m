From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: =?UTF-8?Q?Re=3A_=5BRFC=5D_=E2=80=93_Proposal_for_new_process_for_OFED_releases?=
Date: Fri, 2 Dec 2011 12:15:03 -0600 (CST)
Message-ID: <alpine.DEB.2.00.1112021212410.13405@router.home>
References: <CD250C48050CFB4D95E78C95F2FDDD6E237661EA@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD250C48050CFB4D95E78C95F2FDDD6E237661EA-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 1 Dec 2011, Tziporet Koren wrote:

> We propose a new process for the OFED releases starting from next OFED release:
> - OFED content will be the relevant kernel.org modules and user space released packages
> - OFED will offer only backports to the distros  (no fixes)
> - OFED package will be used for easy installation of all packages in a friendly manner
>
> The main goals of this change:
> 1. Ensure OFED and the upstream kernel are the same
> 2. Provide customers a way to use the new features in latest kernels on existing distros
> 3. OFED qualification will contribute to the stability of the upstream code

Ohh. A Christmas (or whatever your favorite holidays label is) present.

Great, we may now be able to stop torturing our support departments to get
OFED running with this and that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
