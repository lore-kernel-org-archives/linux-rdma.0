From: David Miller <davem@davemloft.net>
Subject: Re: [pull request][for-next V3 00/11] Mellanox, mlx5 E-Switch
 updates 2017-12-19
Date: Thu, 28 Dec 2017 19:46:16 -0500 (EST)
Message-ID: <20171228.194616.2274862427545657993.davem@davemloft.net>
References: <20171228232314.13678-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171228232314.13678-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeedm@mellanox.com
Cc: dledford@redhat.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 29 Dec 2017 01:23:03 +0200

> ==============
> This series includes updates for mlx5 E-Switch infrastructures,
> to be merged into net-next and rdma-next trees.
> 
> Mark's patches provide E-Switch refactoring that generalize the mlx5
> E-Switch vf representors interfaces and data structures. The serious is
> mainly focused on moving ethernet (netdev) specific representors logic out
> of E-Switch (eswitch.c) into mlx5e representor module (en_rep.c), which
> provides better separation and allows future support for other types of vf
> representors (e.g. RDMA).
> 
> Gal's patches at the end of this serious, provide a simple syntax fix and
> two other patches that handles vport ingress/egress ACL steering name
> spaces to be aligned with the Firmware/Hardware specs.
> ===============
> 
> V1->V2:
>  - Addressed coding style comments in patches #1 and #7
>  - The series is still based on rc4, as now I see net-next is also @rc4.
> 
> V2->V3:
>  - Fixed compilation warning, reported by Dave.
> 
> Please pull and let me know if there's any problem.

Looks good, pulled, thank you.
