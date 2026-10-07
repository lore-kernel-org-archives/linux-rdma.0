Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F70B37A4AB
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791390840; cv=none; b=ZuU7kKzJOohCrnxQJcJHkT8huh7C1eSyLJ7wF0/VuFIweehCErIRSnshJlXxuXfgJNY+ME4PBEV5oeheykrE8pR8NgasZnjSxvoszeNz6FolvnPfOjx7eIUxmjrOeohYIIETif791AoOvrfZ6qVY4rtTJgE1OQr/Ny9dbtF95V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791390840; c=relaxed/simple;
	bh=7evDrsn33ZOZyzUJ4PxA3QjtwQoT19qOjju1qVoOdc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bUDemi0f+3ZFrUfzVdi6YuRBpivJoUX3zlD25pHjuBd/pgC3tQa0hIk/p7ak+G7bheb+5v8QBwl+IhghUeqdY63VrLOlfIoeD1ee5YCt1URZvLaGOtg/KIHo1oUbdG/4JV/RtvLNapAUp769qKC/sAI0C5SoJyNh8J+1xnVB6Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oga+ACWQ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oga+ACWQ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so41530665e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 09:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791390837; x=1791995637; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7evDrsn33ZOZyzUJ4PxA3QjtwQoT19qOjju1qVoOdc0=;
        b=Oga+ACWQ80glITGJf9Syxbn629N1NR8aWMjJTZz67vau6xa7Dwi6W+8Sepz4G59NLh
         02kMBmhByo9EIIBpNGwxzSZ5OxGq+nxCwZ81dtNC5+4f47+6pMvjpKMFkeeAtjir+Jb+
         Qpg/bLANel154jR3mIkcCZeaZkppiE3/7m+EpQspgi9E5+aNO1Ct/sU9zmbUrpETNkvm
         5QIKxGzDdR8hLTTY7IIoNec6JF7JIe9qWyOFmzbWRbqfz75OwU2W5L/NCWyiSZcymRoV
         KlbdXF6yUfa7hbExAVC0chlXI+GW5kzLDcmACVk44Di7DJEkbKWE77DODevJlPWwVFSF
         fVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791390837; x=1791995637;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7evDrsn33ZOZyzUJ4PxA3QjtwQoT19qOjju1qVoOdc0=;
        b=RobLCKiITo6x8pcOA5uK+rQmcvhdQbV22+LXTVWlu/2i+c2skxhIH03llnR3g4naTW
         NcV4OSR87OBREumfnhwidN1mTi5hyEjhYhhkgHK3O9kjR/LtTnDYtTQaITOjLEbaYGtp
         q1ZHtFU+mPevW3EG8nqPnlKdGSWSH5KNC/iLHiwanHZu+GOSsYjWCHDpsGcgj8rED4Tu
         PALnmYIZ/ifpdzzJJU+6aAaiW4Wlwn+cMVtQgcc+wDMvoU20CTetg6JhGBqzsN/+WmJT
         Uruh3TawNbBm7SyCJQQpwj0a7XczIy6WwDe0e3ioLBRy3/vbCIAoTekf2zZpx/GMH+Sz
         HjBw==
X-Forwarded-Encrypted: i=1; AKwUvBykvwqpOO3aST+svnDHvOk4v8U8VwREDIWiLaY7Zjpc8o28WP7NEDHrdBj023UfJqJsqzlwbfxbAZFy@vger.kernel.org
X-Gm-Message-State: AFuF++mlHI+CCPOQejB0PqWoNcNo5JBVE7WRCwUBnR6QAnFvSkSbnncW
	gynf8NRQDk4pyeTZD6LBgealhTCY7SOgi8Zax0cZJjrFm5OYUy2yNGQ=
X-Gm-Gg: AYBFou1qheNVkQ31gdBHsDflwtIdA8EF9Dv8q00XwEUXjClgdMX71yG8twzymxTzMVi
	4D7P7oalOX8cHaPe2E9NFJh8AeheHlLwRvUIuNnFtB0QD/3Hw1jydp5JmNFBEbmGFTXhMvJEwHz
	1oRpu6xCTpUHMwQNWlhKXoEt++i1KDLZRJHcDZfKxhLB6Cxb3A3xekIyXo+Apz7n6WPisJjWvh6
	GcRPHusEtsjJ/K6QP5QnxO1k05UrC23LqfSyR7NeOsbHK2+uJq645G3r+TqreUa6zIuOzKSK6w2
	HBRecIzR0c8iwiQHzdrZeuBbd3wKmKwe/pctx1Vk7JoZxp+8Tzb5IVYoVO/yRR6cDeZfGuXMpuE
	+mJLwtU8GrfyeCf2VwkcK2o4QWj/wcKxFlfKUxHiaRGi0ia8jgzVBRdkQujV5sOo2CTFR6e8Smp
	QDZSQziWL7X+AdFPe1zmM2vibWuEqFQlJJ4foKcphsln0VPzU8rg==
X-Received: by 2002:a05:600c:1551:b0:4a1:7733:5102 with SMTP id 5b1f17b1804b1-4a180443559mr44304695e9.15.1791390837363;
        Wed, 07 Oct 2026 09:33:57 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71c0b860sm5647218f8f.11.2026.10.07.09.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 09:33:56 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] RDMA/rxe: copy completer WQE to kernel buffer before processing
Date: Wed,  7 Oct 2026 16:33:55 +0000
Message-ID: <20261007163356.407937-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830191344.2026524-1-tristmd@gmail.com>
References: <20260830191344.2026524-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Zhu Yanjun,

Gentle ping on this v2 series. The v2 addresses your review feedback
from v1 — bulk memcpy() writebacks were replaced with targeted
WRITE_ONCE() for individual fields and smp_store_release() for state
transitions.

Would you have a chance to take another look?

Thanks,
Tristan
