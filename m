From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v5 4/9] IB/core: Enforce security on management
 datagrams
Date: Wed, 23 Nov 2016 09:34:12 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1611230933520.3895@namei.org>
References: <1479843638-67136-1-git-send-email-danielj@mellanox.com> <1479843638-67136-5-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1479843638-67136-5-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>
Cc: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Tue, 22 Nov 2016, Dan Jurgens wrote:

> From: Daniel Jurgens <danielj@mellanox.com>
> 
> Allocate and free a security context when creating and destroying a MAD
> agent.  This context is used for controlling access to PKeys and sending
> and receiving SMPs.


Acked-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<jmorris@namei.org>

