Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD25135677E
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121206; cv=none; b=GWv51kzDOdaHYzOTcGFFMbnEvxpZyMCZcnwhQA1eEKDC23y9PZMzA5/vKqYEN2gv7J1C8zVykMNVWZmH7WTchzY/j9GFaa0GdWUpIijWaCAUnU/tP8Zf76ZS2ATEhcHjqFdob9fyPON/bK3rjYBl7HulIqScSvZfJPtr8WWwP4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121206; c=relaxed/simple;
	bh=wt4EIW2LVoS9ynaG11t5r5iWp9bbWu5ri8hKnpFZ3ww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr1mvnd7srOajKjs3Q2zPJl61pO528DAcwtQ64yP/0+YedTapP7dPiDJmbicMpS7gJhYGBoRqPpl1niapRt4RiG+BI+wT9xbP/0Fpum1ZgyzTfM1TEZGo5ddrttqdAXTq616Dxs9y22zi9p+K4wBBMAVnI6SzSJFrBUPOzp8OnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Yx78VGmE; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Yx78VGmE"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52b6543169fso23214431cf.2
        for <linux-rdma@vger.kernel.org>; Fri, 07 Aug 2026 09:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786121202; x=1786726002; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wt4EIW2LVoS9ynaG11t5r5iWp9bbWu5ri8hKnpFZ3ww=;
        b=Yx78VGmE6ScYLxYbsI2uZu/CQ9VXE4W6yey8hxcHsm+9opjQIo9HhpQZDO0sxWY7gD
         +DlL41R1sHcfQJIpkQ53Cqndt90NYL+fO+CLLSnwJ8ype8GNB/eNzg1twTWkNCCf8ali
         C6BBtwLIm4/gdsbZF7Y7FyRsY+9Y2C+EGeDp+Tm1PBsWD8+gQaR7XQDX7Scq1E9Tm4SQ
         qZ6tdA4G9CN1UI+m7yJWCPGYBm9qRX2qd433oo4F5vQ6n88PbzcHF7mwt0u1QycdHmWv
         Z56fK3sU4lhFMHxnBz/xIo16A/ske5Ez2HsOyAZtYa77VaV438z6iDEe6b0idwfcVew3
         iciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121202; x=1786726002;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wt4EIW2LVoS9ynaG11t5r5iWp9bbWu5ri8hKnpFZ3ww=;
        b=da/FFDIgwAHRIYhkJswQXH1Se87J1j3ToNoNI3ZCgyQiJPcLa79z/ptkOuMd4Z8MDv
         hyBStJo/iTqiNgtvhJ6DfnVe0s25x0BQJkm6RByM8QIqVWtz/7UYxKvKs6suItkLLQto
         vQRpqmqmOILvHVKH1/pWFY2nraobx6KqIMRT/3lojFjNnFFftAK6yX2UJ6fVLxfqPqtf
         7CPGbhzoDq58SdmxCDSozrrWE9kaVemxo0nr103CnYpISk+U9Iiqq8Mn05Z0KWk2W3+I
         HPS3RsuJr+nyKH1ATvXVc83mQWmHwgcR6Eq5U3zjo+Yl/VjwfbdMr6mcKOSUuxxV5Pqx
         J94w==
X-Forwarded-Encrypted: i=1; AHgh+Rqf188vzYnDaaPkEghaIi70bXk3l3Fp93u2kq6EWRxVPVvII5pUzS33U59CbpQdYO1s5uQ3+VSreq9P@vger.kernel.org
X-Gm-Message-State: AOJu0YzKpVsdNN/8MfghEdZII8xHXbygSULu3f554FaJpELo1bjaZ5OE
	LfmhiAe96FzGhe8tpYMIYJ0CExVESOVF2FExJW3Aoc6S7U0NhzOz/5j6DLJLq+UHfABSy6hEB48
	+6Qf1
X-Gm-Gg: AR+sD12IJFb2vuzprr/1GpLVzfmcUzdLUPx8VWqzPq9RjuTW6BjhozOrSXo8Ms9cUjh
	lp4hEdP2m+o2zDG35GjZT4oUHYT7MimlzE1/t9ZZN+sD4gMQkpJ5sISCHcFDD+WpMEf4Q63H+2s
	P7eGm6kuZh8Q6hjEs4Ign8CXOrU9zb9tMKV5VP5agGPjuAsgIAp2P4xWGB044Pitae/U9Yvesr1
	CYUCoSc4hpMKF3bhoBVuwwBDF0j8Q6+x7k07xhoyK4B0LHw5R5CFc91mnj/impHe0+ZHoyuleFe
	0vug0j9m5nA9rBLG1HEYfAkdFZX+fhyBZcFkJaFWv42u++WF7HUMlxoYZHh4dzBU4coj4p8ke/3
	+GOitC8f/FW7BhBy7e8bYpF+rPNZsl/1dMVEIBfwg4SD9Qj4A2HdpHsqp4qHUxfEJDjBAA0R0Q0
	kT9joYgAiVVdqM6jF7oQbNh5Uz7iYfaxQMfIG7Ng==
X-Received: by 2002:ac8:598f:0:b0:51c:1117:c6a with SMTP id d75a77b69052e-52d18e1bb6bmr48017691cf.4.1786121202427;
        Fri, 07 Aug 2026 09:46:42 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d16336111sm15777031cf.5.2026.08.07.09.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:46:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wsNiS-000000014vR-2tuP;
	Fri, 07 Aug 2026 13:46:40 -0300
Date: Fri, 7 Aug 2026 13:46:40 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/hfi2: Add MAINTAINERS entry
Message-ID: <20260807164640.GD200537@ziepe.ca>
References: <178603994025.3611040.18003173777504573447.stgit@awdrv-04>
 <20260807141820.GC200537@ziepe.ca>
 <dccb461b-1a11-4275-93bc-eed163d1ee51@cornelisnetworks.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dccb461b-1a11-4275-93bc-eed163d1ee51@cornelisnetworks.com>

On Fri, Aug 07, 2026 at 11:06:08AM -0400, Dennis Dalessandro wrote:

> So I will resubmit just a single series with all of this stuff combined into
> one set of 24 patches. Does that sound good?

yeah, I don't want to look at it and wonder why it is wrong and then
find it is fixed later

Jason
