Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21253292B2E;
	Tue, 10 Mar 2026 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165484; cv=none; b=dGSrvREQABoMQy61aHbsUxd2sOvXb49NMjJCSHi481761h2Q3qvoOHK7r5RKgZxmtsJpztuK7Sng9q8HkIzTwy7Yosasq+Ouo9H0tNK50ZsHG8O5VHBhBB9dPngWofSZhdeEDh4phpI3R5hX214vwsvyG13/uBnB7oSM0Yj+kwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165484; c=relaxed/simple;
	bh=9H+COjDFYd25DqcGlBZTvFi1KfvZMB8xWPxprb0yqkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UtDTZFldyXzg1y6KIX5boYEGkLsMsYcP0I1xhLTqixZwOm7fD8Za0c1dS1rV5PgwoqN0Lg3vpDrHJBL92CeM/8NjN/KRrXhYg/BWV0LBRJfCur6KwtC40BVqz58oWb0m73YzPz3wwm/LLYAfZfV49dT/EIKpKebLze3QjcVlYhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6z1Z5Sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6z1Z5Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4070AC19423;
	Tue, 10 Mar 2026 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773165483;
	bh=9H+COjDFYd25DqcGlBZTvFi1KfvZMB8xWPxprb0yqkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R6z1Z5Sy2ONUcvt/esaL4cfMvnCnz+4WQK9rersFXhEMOXIbcz2hY89OitB+uxloh
	 XfbM5sNkh990asp+zh4GFiaz3D1Npib5FIHQLRT7vRKJssXCHm103H9GH0l895nKRU
	 sG5Yr1DrnH08JQ1T0zNjFnU4oEYfDlbMv7YYOiaJpxXkP6YLaaCUlDPEaksjFz9ren
	 BpVy3QyVJ+R9a0NJdGjTXLW9uuGWkg7qKZMYs0zNeOiGO9BJzrdJVK6mBfnIqEIlcY
	 Zlowom/kUzVzoyqTgQHo7VLQGGkdE4synuGRF+QFfIQy+4JGSBHY1ePzd7/tLhSngP
	 LdosCRUWeRD+Q==
Date: Tue, 10 Mar 2026 19:57:59 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@nvidia.com>,
	Itay Avraham <itayavr@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, Chiara Meiohas <cmeiohas@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>
Subject: Re: [PATCH 0/3] Firmware LSM hook
Message-ID: <20260310175759.GD12611@unreal>
References: <20260309-fw-lsm-hook-v1-0-4a6422e63725@nvidia.com>
 <CAHC9VhTR9CsBgxRCAHXm5T2NZ5tr+XfmA--zkt=udmk9hPRuZQ@mail.gmail.com>
 <20260309193743.GZ12611@unreal>
 <CAHC9VhSRt_QEJKJFBDBySNQCiPpcawd5A76xmoRNtppRKGaCog@mail.gmail.com>
 <20260310090733.GA12611@unreal>
 <CAEjxPJ4nTmovpgkzC+3=Oh7EAhpi1vHLwJfjezu-vzX_Q2OCug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEjxPJ4nTmovpgkzC+3=Oh7EAhpi1vHLwJfjezu-vzX_Q2OCug@mail.gmail.com>

On Tue, Mar 10, 2026 at 12:29:40PM -0400, Stephen Smalley wrote:
> On Tue, Mar 10, 2026 at 5:14 AM Leon Romanovsky <leon@kernel.org> wrote:
> > 1140         MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
> > 1141         err = security_fw_validate_cmd(cmd_in, cmd_in_len, &dev->ib_dev.dev,
> > 1142                                        FW_CMD_CLASS_UVERBS, RDMA_DRIVER_MLX5);
> > 1143         if (err)
> > 1144                 return err;
> > 1145
> > 1146         err = mlx5_cmd_do(dev->mdev, cmd_in, cmd_in_len, cmd_out, cmd_out_len);
> >
> > Could you point me to the LSM that would be best suited for performing
> > checks of this kind?
> 
> If you just want to filter on opcodes, then the SELinux extended
> permissions (xperms) support may suffice, see:
> https://blog.siphos.be/2017/11/selinux-and-extended-permissions/
> https://kernsec.org/files/lss2015/vanderstoep.pdf
> https://github.com/SELinuxProject/selinux-notebook/blob/main/src/xperm_rules.md
> 
> This was originally added to SELinux to support filtering ioctl
> commands and later extended to netlink as well.
> 
> If you truly need/want filtering of arbitrary variable-length command
> buffers.

Yes. The opcode alone is not sufficient for any real‑world use.  
It is not reliable because different firmware versions place different  
parameters into the same mailbox entry under the same opcode.  
Without inspecting the mailbox contents, you cannot properly filter them.

Thanks
