Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2D323EAAB
	for <linux-rdma@vger.kernel.org>; Sun, 15 Feb 2026 07:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771139234; cv=none; b=XjbLuhemYeaO6jExgxuwfn7CplA/EaRd1oiBzrzcgBwWCJ/lF9zfWsi7T/Au7XF3x9Do9f6/qpVD4Gy4WlP97WEznsrqT4XwO+LN89cY56uFylQiQTiT6+BiUbLLEv3kyPtcF+EpY5RQ3PF97KQ5acf5OQWcCbPNpWqjcapDtH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771139234; c=relaxed/simple;
	bh=ovKTuxi3/2eJl2MrqeC4OgV28mX3fTa6IifHd40vnVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dPNaKEiwsQoECqk4aFUNqKCFJLl+e6QzYDW300ZAhZ9jN4SrP5UndU1ccZQ6oHAQ6zj5gyyUiRoO1RJY7bMAkg2ujZrG45uw/prSwmIRK/0CFd8xjugisnoWYsyKlhnz53yG2RQRuN5a+e+3f2Rw3BR4uoXeFyXagN8edhn3374=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fi3xQ4cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fi3xQ4cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B770C4CEF7;
	Sun, 15 Feb 2026 07:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771139234;
	bh=ovKTuxi3/2eJl2MrqeC4OgV28mX3fTa6IifHd40vnVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fi3xQ4cxQOkMpE+KzOuZHU+aDFHxQpOs6C2cEgW/DmPBZtFmQR47h0nvyuFLvnsvp
	 b+P5QSVnr1kWqdB4UQ2IJ8aTZIT8g4A5Gl4+gj+QTO9HC/kcpzZaJuTZpoL0E3ffj8
	 W+9Nm2MkDVkbZFXvhFNCpauWiSqIs7NfoAewoYnc5nzxuBdgZOT7PvWv5McR6NI96a
	 BH+EqQJ70mQACe6G22T91A+m7ArhCU4cNZ9KEUU4y3VqREoYbXpfiboV2VZ1y/Dt4n
	 C/hazdV4jkTOnFKLqtT9n3MVi5DydWF2y2GTsRvSGux8q7Lq0hWIFFQU5usqfyp7hr
	 GjeKrCzEA77VA==
Date: Sun, 15 Feb 2026 09:07:10 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH rdma-next v12 5/6] RDMA/bnxt_re: Support dmabuf for CQ
 rings
Message-ID: <20260215070710.GC691383@unreal>
References: <20260211124927.57617-1-sriharsha.basavapatna@broadcom.com>
 <20260211124927.57617-6-sriharsha.basavapatna@broadcom.com>
 <20260213111256.GO12887@unreal>
 <20260213145425.GN750753@ziepe.ca>
 <CAHHeUGX8Ga+xtqJ+K-yQ=bpFLznPamdHrOc8ydE6V_POh0BJvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHHeUGX8Ga+xtqJ+K-yQ=bpFLznPamdHrOc8ydE6V_POh0BJvg@mail.gmail.com>

On Fri, Feb 13, 2026 at 08:33:06PM +0530, Sriharsha Basavapatna wrote:
> On Fri, Feb 13, 2026 at 8:24 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:

<...>

> We have already been reviewing the changes in Leon's series and we
> have noticed at least one issue with the bnxt_re changes. We will
> reply on that thread.

Did I overlook that reply?

Thanks

> 
> Thanks,
> -Harsha


