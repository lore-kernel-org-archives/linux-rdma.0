Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4806D37E2FA
	for <linux-rdma@vger.kernel.org>; Tue, 12 May 2026 20:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778618420; cv=none; b=M+HW/VrhT78jX2GMKrz0ULh1ZKIGE6bJH1StjiSPXyQB5H/KysFUyv/kG1ThMfx+SqxOs6YtrBLY26wQRSF6Sk8SuyJyoPv8LhvAblEucKC6Jj798N8bayojYcCx7FLvHR3Gesuf8gHIbavR+1V1WqWlnVP6OPm5tV70JMQwrOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778618420; c=relaxed/simple;
	bh=I+NQtUSkIZVl3wvjU/4fL+WPlKKi+sufLnArjOiNdn0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VrRAHUZf5h+edrCciTMl+Hqp2NpnjRJlkBNH5nN81BZvx03JL3rVsblxWGNza+yd27Soa1iRxGOOJTJIM1LCIhKE+prJ7NR1y5sdmQNvQ/J9JTHXsvTeG5bSpv9HwH+Jp70v/JZwECitq3CCIqrcG6rkK+ZzS4gI2CNDvO9Zkf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YWVkGcmU; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWVkGcmU"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6966d0665baso3631885eaf.1
        for <linux-rdma@vger.kernel.org>; Tue, 12 May 2026 13:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778618418; x=1779223218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+NQtUSkIZVl3wvjU/4fL+WPlKKi+sufLnArjOiNdn0=;
        b=YWVkGcmUqbkiMdcPJ39+Jl9RrJ3JufrUzA+jhtu0lHflaXo7PZ1kAqzkcO79kWTEkV
         x82olLN044IgpdUSmYJRHbcpyljPYns5Gcj/kufUO2534fJmQsfmSUycZJlvRbYUjoZf
         K8wTPm/hiCmbCKtlnv3BhPniYNTBvcZyzbgD/HKUtB6HZbII9sUdAf/FlwnnN4bUVWKU
         KOQE9zpFqFXVM7MTTfUfYuO3K94x26fykLNIqZQRRzwHB8fKebII5KkVLTCqOA6suAi2
         FIORoG5ySgNwpg9UH/rq7MxA+NDwGpSp0NkDVas1bJ48g3SgcCPefmxrwFoT3nlC0Grm
         PyzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778618418; x=1779223218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I+NQtUSkIZVl3wvjU/4fL+WPlKKi+sufLnArjOiNdn0=;
        b=mSDFWrNiHbF5553/RSxy7uIthhhFEM2S1LCcXqltTo//mcCTBzs4PBaOY0UNGJ4dkp
         WlkK5fIpPjd4e8gw8J4VtjgoirkMCyKS8Hh7HZBApzJHiCOlWkf9zE/AGTcpjslkezdg
         XqU5FzmTN8fVyNyiTMQAnXbBamJivyE2o4QrhGhaTPCeD1j7JNf3y/14/QLmiwOLQTkh
         4Kr5FiMeJzkclkabxYodNfAFEiTAo5fZDjysYZfCRijzgbMSNups1+Hi/yKdL6+Ce9sV
         jCF+FlyGzZ4bhlz6P36KXEDv1JejDB8OaeYB9MiHfUXRdV/vq4xUiEv54qKdDVidhOYt
         Dlkg==
X-Gm-Message-State: AOJu0YxSU2S3vHU4x+TazGOsIOGpp75AmYRu3ZoWYt5jqKmHyRhO1nSQ
	e2WeZhEKYMONSFCuskT8issK5pzuIiZc6qB/N+knhsfRtiW833V8k74c/ZEuaA==
X-Gm-Gg: Acq92OHX+oQC8/Mi8sGNHOIJOwOLukQ9+Hof91bZVmw9/2+tk004YO6h7L3SbWGKD/6
	EkMjQGM9V//WowUGzcUW8Q5mCTzrIwmQTVmDD3um9aE9JPBCNW0KiI2aIo4v0+dQdH7oOM0QiAw
	I7h7VHPM9VKEDtVRUcbAiQ2TXyEMrWjtHlrkPR13vz4AQHw1bDYxO6KKefr6iekZ/mSpaVpSlLs
	w1QVyxwOZPUyv3TFFQ+eQkPEHwyVKOtfrXXyMz0xhJwSL9FsC3UfWduVpMawTjjwwpQlXVm2jks
	ZLoMn0/CsS5j4YORT6DCuDaUnUtXIfC7Qm3jjJPFEZamci4CGtvCaWaDTnzezy/WaYzcCWeBtKA
	vWPhTqbk2qy2B+7kMDgnhNzc0F1muSZU5xl945QxMaKziSi4MH5mK6VQdSOTmkletMieEyZEyxE
	KffB3Gkc9AcVjXEbOJguktjxXn0zoQJA7x4kF9YbAwm9cbTkADGr4fa34144wrTA==
X-Received: by 2002:a05:6820:4b8a:b0:67e:16b4:aa13 with SMTP id 006d021491bc7-69b78e08feamr270971eaf.58.1778618417974;
        Tue, 12 May 2026 13:40:17 -0700 (PDT)
Received: from localhost.localdomain ([2600:1014:b0b0:a3c6:a82b:c292:fd90:24d0])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439b9a83c9asm1571007fac.15.2026.05.12.13.40.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 May 2026 13:40:17 -0700 (PDT)
From: Liibaan Egal <liibaegal@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH rdma-next 1/2] RDMA/rxe: add local implicit ODP MR support
Date: Tue, 12 May 2026 15:40:15 -0500
Message-Id: <20260512204015.32113-1-liibaegal@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260512201453.21156-2-liibaegal@gmail.com>
References: <20260512201453.21156-1-liibaegal@gmail.com> <20260512201453.21156-2-liibaegal@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

One clarification on the wording in the cover letter and patch 1/2
commit message: when I said the per-transport ODP caps describe
explicit ODP MR semantics, that was too strong. What I meant is that
this series leaves the existing per-transport caps unchanged and
implements only the local lkey implicit-MR access path, while
rejecting remote rkey, atomic, flush, and atomic-write uses of
implicit MRs.

The intended review question remains whether advertising
IB_ODP_SUPPORT_IMPLICIT is acceptable for that local-access-only
implicit operation matrix, or whether the cap should wait for broader
implicit coverage. I will reword this in a v2 if the series moves
forward.
