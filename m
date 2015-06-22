From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv2 RFC] IB: Add rdma_cap_ib_switch helper and use where
 appropriate
Date: Mon, 22 Jun 2015 19:48:47 -0400
Message-ID: <55889EDF.3070906@dev.mellanox.co.il>
References: <5583536C.3010504@dev.mellanox.co.il> <20150622202056.GA8049@obsidianresearch.com> <55888813.9040803@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FF7EC2@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FF7EC2-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/22/2015 6:40 PM, Hefty, Sean wrote:
>> Note that there still remain a couple of node type checks in the kernel
>> that we may want to remove. There's an IB CA check in cma.c:rdma_notify
> 
> This should check for rdma_cap_ib_cm()

IB, RoCE, and OPA ports have the RDMA_CORE_CAP_IB_CM set so this seems OK.

For IB switches, there are 2 cases: enhanced switch port 0s can support CM and base switch port 0s would not so this seems better than the IB CA node type current check.

> 
>> as well as in rds/ib.c:rds_ib_add_one and rds_ib_laddr_check and
> 
> Not sure what the underlying reason is for these checks.

rds_ib_add_one says:
/* Only handle IB (no iWARP) devices */
but not sure comment is 100% accurate as it checks node type != IB CA.

rds_ib_laddr_check says:
/* rdma_bind_addr will only succeed for IB & iWARP devices */
/* due to this, we will claim to support iWARP devices unless we check node_type. */
It's similar to above in that it checks node type != IB CA and does not seem 100% accurate.

Comments and node type check are from Andy Grover back in 2009 (in the original RDS commit).

>> an RNIC check in rds/iw.c:rds_iw_add_one and rds_iw_laddr_check
> 
> rdma_cap_iw_cm()

iWARP ports are the only ones to have the RDMA_CORE_CAP_IW_CM bit so that seems right.

> The intent is to clarify why the checks that exist are made and replace them with a check that clearly conveys 
> what the restriction is.  So, yes, the use of node_type should be replaced.

Understood.

-- Hal

> - Sean
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
