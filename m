From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v5 9/9] selinux: Add a cache for quicker retreival of
 PKey SIDs
Date: Wed, 23 Nov 2016 09:53:04 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1611230948300.3895@namei.org>
References: <1479843638-67136-1-git-send-email-danielj@mellanox.com> <1479843638-67136-10-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1479843638-67136-10-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>
Cc: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Tue, 22 Nov 2016, Dan Jurgens wrote:

> +static int sel_pkey_sid_slow(u64 subnet_prefix, u16 pkey_num, u32 *sid)
> +{
> +	int ret = -ENOMEM;
> +	struct sel_pkey *pkey;
> +	struct sel_pkey *new = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sel_pkey_lock, flags);
> +	pkey = sel_pkey_find(subnet_prefix, pkey_num);
> +	if (pkey) {
> +		*sid = pkey->psec.sid;
> +		spin_unlock_irqrestore(&sel_pkey_lock, flags);
> +		return 0;
> +	}
> +
> +	ret = security_pkey_sid(subnet_prefix, pkey_num, sid);
> +	if (ret != 0)
> +		goto out;
> +
> +	new = kzalloc(sizeof(*new), GFP_ATOMIC);
> +	if (!new)
> +		goto out;
> +
> +	new->psec.subnet_prefix = subnet_prefix;
> +	new->psec.pkey = pkey_num;
> +	new->psec.sid = *sid;
> +	sel_pkey_insert(new);
> +
> +out:
> +	spin_unlock_irqrestore(&sel_pkey_lock, flags);
> +	if (unlikely(ret))
> +		kfree(new);
> +
> +	return ret;

The error handling is messed up here.

You'll return 0 on kzalloc failure.

Also, if security_pkey_sid fails, you'll attempt to kfree 'new', and you 
don't need an unlikely() in a slow path.


-- 
James Morris
<jmorris@namei.org>

