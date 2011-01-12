From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 6/6] RDMA CM: Save Owning PID
Date: Wed, 12 Jan 2011 14:54:48 -0800
Message-ID: <ada39ox4ts7.fsf@cisco.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>
	<1294068834-17778-7-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294068834-17778-7-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org> (Nir
	Muchtar's message of "Mon, 3 Jan 2011 17:33:54 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +	spin_lock_irqsave(&id_priv->lock, flags);
 > +	id_priv->owner = current->pid;
 > +	spin_unlock_irqrestore(&id_priv->lock, flags);

What is this serializing against?  I can't see what the lock could be
protecting against.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
