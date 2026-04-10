Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324952FD1CA
	for <linux-rdma@vger.kernel.org>; Fri, 10 Apr 2026 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834713; cv=none; b=rlmrm2pvfsjojFQcPbyUR2ro7sQ98IVWeHwy4cJQbf8uc3e4MVzBh8r49KU1GCc6+eyC9iLyteX1XLwMQlkbi2F66ywTGj95dRdnq+jZy+1G/ao8808yxwFKzUNGZG4jcb9x+B7H8Nrpqe8XGa4YM0v34jZvVKbDMy/nRk8NSnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834713; c=relaxed/simple;
	bh=wXGIz/wJjCbQPq2+wxI2+JaVeVKCCPWkQsiAbgQVnUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3AOt5FudUcZoS/qox7g4zZwfWx0IiqQtJ8klq5ToeYnvwYrAyCKLVU0zEmFEJ0hqOBOvVNwKmvJqO9o9Cabw2Ok8uXd/Ww/E+w2QlK9hPIOb5w/WtBLwGmgFfmeLHYLV9a06RowrHt/tql+59gVWL/G7RNoie7PSdV4Ycjlie8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=nBn7ni0O; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nBn7ni0O"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8d4f78fc9f6so252590285a.3
        for <linux-rdma@vger.kernel.org>; Fri, 10 Apr 2026 08:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1775834711; x=1776439511; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=//vYyQEZCPEleKFNzW/IBUjhzo4lXyeQ+jvKUfvukfg=;
        b=nBn7ni0OeeJZWCjGWBavQ8XMZ7E4VYQn+ESULBQ0ZoqWMNmrbLYiLJyqTsqzNYQNeU
         eYozli/GgBN9766LDwAtij2CZLrohlyOLwnp4aYg4fSxddZ8MV/nDfuJ/2ItT4Xqlx6I
         Z8JkbAlK2KMCYwHSh8RjCWjaZ0dEHGf6oyxU+6EwswWR4xHbIWz6Mk6eJDlKlI81hs/D
         Lu6gbzOuQwivI1OZ2f06RE6KlakbjlDabvgU/uiFXCX+alH9gUq7DD7QHDXRUwAXwwmC
         WG6cB8M6Z17jaEOk7C5B5n3VFNdTrGj0/8NGBM30nQCnE5wDThprJOrMbwRk18TrD/T+
         nDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775834711; x=1776439511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//vYyQEZCPEleKFNzW/IBUjhzo4lXyeQ+jvKUfvukfg=;
        b=n6M6/Jz5HGo50f3/ZJWC5XABzwaQvZgoadEHw/y7gNHF5RFsUb7H66Qix9PUVO/Myx
         03KIBnUa6/mLIOiE4LD6sArQKmPPqa3VuSEtLiebDXV4Fq29ofFbJ/EOgFX4jBom1kKT
         ldyBhULGqhgyGJkom9XMMzCuWe/JOZA+97sa5iyXJDU7j5q6nriAgj06a8ynVf4l5pHa
         UIu6WyZnWiFRXyrwbxj+qTaezjyHehQ8AER4vUSWifRcSaDpxqVDxexnxbELAn07Yy8X
         paDyk686ZH47EoazvCQPKDGaeNx4yIF4tYsxaO/np87t0w7e+j+xHlLees9Z/gudUZDI
         5bPw==
X-Forwarded-Encrypted: i=1; AJvYcCVMYsrIv9mquJz3JjKI5AKzt60oQgQBHBnadHq1lVn4p+PCwYTzYwuzK+uXsQ2i62xz2Mi7I+we6Uzh@vger.kernel.org
X-Gm-Message-State: AOJu0YyE7bB9Ne69b5tuyb3Wlm6UqBhLU9JfVm/nve5Da3Ut7LExGtCY
	FApZh58qHzYTavaEeOCTFu3wXwzXMCsU4adE8mhwmOQO6EX1kiHaEb/vKofcs623fgQ=
X-Gm-Gg: AeBDieuBvtBRhNiVw0DauP2ZfEyIBtrI0BuA3/5ehLzJlnyVRB+Q2vXwYidgZDG0iuF
	xIsRi5QbmQl+fiAAK2Pm2xuRuZ6YoHwP5EWlRBqf2BmBRENjx1/hcc+hFnIFFFWt6jQPCPVtNJg
	56uUQobgqfQ5mOIKUtbHQY1X8S/0R+HiUt+ArJqOiILSkDbj1c5Jn90X5e6xrqQod20sHzzxcWk
	TtYJEeo0BDZsLTeAHt6hG1Owfs2IAoHx9HMD/giUrib7ln2FAjYXNPLLQgQt/WDLHg3Q7uv22k5
	0E+6Yrt9vHYKqUMBLrP+9bZYCgHq1zZrJ0GSCOanQSNfyGTpClQ60L7zEYcHGThhAWLbU/Pjior
	u6cJD02gEZ5fyZ/iVuWYdEH0dPBDkJEFF1mv4ErVAc4+Iw4mI256q08Kk3/7E8YziEaLtkgSq5r
	bMTje9sxgjDl4TLweeKLfYp3WYzPOt+G89lWRD/JbshYiholWo93PCJkkeuAr4NXHCW1/lYQ==
X-Received: by 2002:a05:620a:488d:b0:8cd:8fb7:7b06 with SMTP id af79cd13be357-8ddcf2b0eacmr483096485a.40.1775834711021;
        Fri, 10 Apr 2026 08:25:11 -0700 (PDT)
Received: from ziepe.ca (mctnnbsa70w-159-2-73-22.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.73.22])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb5f89ccdsm218393385a.5.2026.04.10.08.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 08:25:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wBDjJ-0000000EdVJ-2hQh;
	Fri, 10 Apr 2026 12:25:09 -0300
Date: Fri, 10 Apr 2026 12:25:09 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH rdma-next v2 0/8] RDMA/bnxt_re: Support QP uapi extensions
Message-ID: <20260410152509.GX2551565@ziepe.ca>
References: <20260327091755.47754-1-sriharsha.basavapatna@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327091755.47754-1-sriharsha.basavapatna@broadcom.com>

On Fri, Mar 27, 2026 at 02:47:47PM +0530, Sriharsha Basavapatna wrote:
> Sriharsha Basavapatna (8):
>   RDMA/bnxt_re: Refactor bnxt_re_init_user_qp()
>   RDMA/bnxt_re: Update rq depth for app allocated QPs
>   RDMA/bnxt_re: Update sq depth for app allocated QPs
>   RDMA/bnxt_re: Update umem for app allocated QPs
>   RDMA/bnxt_re: Update msn table size for app allocated QPs
>   RDMA/bnxt_re: Update hwq depth for app allocated QPs
>   RDMA/bnxt_re: Support doorbells for app allocated QPs
>   RDMA/bnxt_re: Enable app allocated QPs

Can you split this into two halfs, one just QP stuff and the other
allowing QPs to use different umems? I think we can merge the first
part more quickly

Jason
