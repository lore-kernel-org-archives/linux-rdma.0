Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791C33AF65A;
	Mon,  1 Jun 2026 13:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780322355; cv=none; b=jg3JYSfNEwwzyUQol0GNZyjxxnKZkEKCSV/ZSjyMWrz9QAd1FFn+TXi77v+kMKAiBYsqnVk79fbaPRas1kgjXKrii140hqcwT42+vQ0hjOfoxfp2Po5MoE/rvkKjju67RrHJVwIofVvOqqCB1ZJEOexY/jUpvGogpw4VDuimbPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780322355; c=relaxed/simple;
	bh=lhyESNzW9yXHOuF1ceWWuQKLo9wSFTMO53gLZbxJ3eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9SYnNr/ECFLE0fDMQs0ADcjFgOLONeN4AUQ7rgpu6QDh4qxF8aURZ2R+p+B8HhoC4fbDhM5rtp1Sg2/7nuMvRPNeoRhI9nvDkbFzZVtWcbbNnE7oyJAM43DiHqF6lkI2JFLO8qPCzD9OQhH+vslkGtcybHZoymhcmKls8r+lW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=NK3dHBlJ; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="NK3dHBlJ"
Received: from localhost (unknown [10.10.165.17])
	by mail.ispras.ru (Postfix) with ESMTPSA id 4994B45F79A0;
	Mon,  1 Jun 2026 13:59:10 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4994B45F79A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1780322350;
	bh=+eS51S2gLXZ2dNb943antprMpq4prz3+rIEidKZfs/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NK3dHBlJANA4pOEq28Bn4rigwMLaMg0pZuadDGObQXsz8Gw/ZECCBunErdaZQUiTu
	 Je+vlpeepOztFcuA6iHLim4u5aXWMF9Q+d7onhJRXsFfgkHqBQF2Smk62B+x+VP4hg
	 s4jBPpI5WU2/S8SQXzmh4OxJqYBSVWqSg5yKRyGw=
Date: Mon, 1 Jun 2026 16:59:10 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Vladislav Nikolaev <vlad102nikolaev@gmail.com>
Cc: stable@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Haggai Eran <haggaie@mellanox.com>, lvc-project@linuxtesting.org, 
	Leon Romanovsky <leon@kernel.org>, Yonatan Cohen <yonatanc@mellanox.com>, 
	linux-rdma@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>, 
	Amir Vadai <amirv@mellanox.com>, Kamal Heib <kamalh@mellanox.com>, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, 
	Zhu Yanjun <zyjzyj2000@gmail.com>, Moni Shoua <monis@mellanox.com>, Zhu Yanjun <yanjunz@nvidia.com>, 
	syzbot+cfcc1a3c85be15a40cba@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10/5.15] RDMA/rxe: Fix the error "trying to register
 non-static key in rxe_cleanup_task"
Message-ID: <20260601165404-4e37c4ba7b9a60b739186cc0-pchelkin@ispras>
References: <20260601105336.3023-1-vlad102nikolaev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260601105336.3023-1-vlad102nikolaev@gmail.com>

On Mon, 01. Jun 13:52, Vladislav Nikolaev wrote:
> @@ -785,8 +785,11 @@ void rxe_qp_destroy(struct rxe_qp *qp)
>  		del_timer_sync(&qp->rnr_nak_timer);
>  	}
>  
> -	rxe_cleanup_task(&qp->req.task);
> -	rxe_cleanup_task(&qp->comp.task);
> +	if (qp->req.task.func)
> +		rxe_cleanup_task(&qp->req.task);
> +
> +	if (qp->comp.task.func)
> +		rxe_cleanup_task(&qp->comp.task);
>  
>  	/* flush out any receive wr's or pending requests */
>  	if (qp->req.task.func)

There is another

	rxe_cleanup_task(&qp->resp.task);

call at the start of rxe_qp_destroy() in 5.10/5.15 kernels.  Should that
be taken into account as well, like in upstream commit?

