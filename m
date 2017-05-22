From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v7 3/9] selinux lsm IB/core: Implement LSM notification
 system
Date: Mon, 22 May 2017 10:15:21 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1705221014400.3502@namei.org>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com> <1495198139-69993-4-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1495198139-69993-4-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>
Cc: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Fri, 19 May 2017, Dan Jurgens wrote:

> From: Daniel Jurgens <danielj@mellanox.com>
> 
> Add a generic notificaiton mechanism in the LSM. Interested consumers
> can register a callback with the LSM and security modules can produce
> events.
> 
> Because access to Infiniband QPs are enforced in the setup phase of a
> connection security should be enforced again if the policy changes.
> Register infiniband devices for policy change notification and check all
> QPs on that device when the notification is received.
> 
> Add a call to the notification mechanism from SELinux when the AVC
> cache changes or setenforce is cleared.
> 
> Signed-off-by: Daniel Jurgens <danielj@mellanox.com>


Acked-by: James Morris <james.l.morris@oracle.com>


-- 
James Morris
<jmorris@namei.org>

