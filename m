Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88748359FBA
	for <linux-rdma@vger.kernel.org>; Fri,  6 Feb 2026 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770369857; cv=none; b=k99dwLxtcbZCgQJIYRCXwluZt9XKHxzYcdEcKPxpF/9F5g3mvmpSfgkREY4XRl+qx1QFZ3IKU27r9ujd4ZKJ+XZEfU2sOTtuWPjHJ0XXq+z3+TZiOy7kSUnwTE/2eKkteoYpzxg9pfHyVgl04KwSYXh3Itr3+UpS7m2qkkrrz7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770369857; c=relaxed/simple;
	bh=P50Q9DHDNQka2qrgw513BMd3JIx3mSPm10k7dGqR+X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XxtkKfBJnnmQAQJt2EreLEmA/DiS9dwU7/LiTE9t421wJX2eCnfeiMc+i3sN1tZjwI65ml/CKEbLgDkVaPAdMcsTkt1Syk3YF+TCf+X6U5zYskc3sg9pYa+fP481l4Q5/Ef0zP3x5CoLdbnyhClDhyAbQabNqg1bJ40gm6BAcko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=hA7rGr+v; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="hA7rGr+v"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4362d18bb65so162385f8f.2
        for <linux-rdma@vger.kernel.org>; Fri, 06 Feb 2026 01:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1770369856; x=1770974656; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P50Q9DHDNQka2qrgw513BMd3JIx3mSPm10k7dGqR+X0=;
        b=hA7rGr+vuf0mvhOas6mZuuAsd6tK6ALSjbAZ/qxozj4H/A7N/1wQ6/FUpAFkUjPxlY
         KKW2OUSCgEYyyF1rdvsxNIKlQ3ooQHN3cUjA59CLk2tipXiEZ/7LbmR44b/OHmONpI0Z
         +mI9Hg5iYcJQ3deDEjmj24WoAhS9xaFNdKSr4TuyL/dyeOkn5wI8H2HIrvCpqpQIJgpB
         pEZoI9Y/tLQDPjP2CwsDuotVOrn/JEJ0OkEk53jvXUOnicnZT/w9/lETYxPpcGNjeu/Q
         UXZmRNmulTQ2UyTUosRWcioXUHcZPaQaGxtEnGMbh6iZmcmikdpmopjcpwCMeGTJL23y
         Po6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770369856; x=1770974656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P50Q9DHDNQka2qrgw513BMd3JIx3mSPm10k7dGqR+X0=;
        b=Oa4snylgz3PgdgMsnKONBnqv3VI88tny75p3wEE4PEWkXlMvK1gZXq/JzwUp70nUMw
         hNLv+M4eOGDfS0Qu6R27wF94aayMxfWrUdZCFoXF/yGTGDVC0vpq3NYMhtcPb56QgqWX
         rBy6jeRkv3tGNw1QKplIw9H7dbcaPc8DTfXEHISzkfrj90DvRBANO5AFSPf/mlEP2ARM
         QS0p09cjongBmKRehLkFEHX2AHyB7AbzLvMXxANMiki+DvDFdDC35wO3E4ENM091RLvA
         HfgpmPTHbZb6PIUi+WVqxIlyamFR1yTIUOdGwQXJ2NSBoyUdqBqpvEwC77CM40eLKJtx
         Cjxg==
X-Forwarded-Encrypted: i=1; AJvYcCURW12eQ44V0v1/iwg7bMwbC8K5jGJTqWrekPgOml4P3XXMDuYJbfagPVp6nGBjWHu3Six9rLps8OYO@vger.kernel.org
X-Gm-Message-State: AOJu0YyUvHvuiEqmH+DgU6BCELbZ/c7MPF/qjGuSG3do93fmO50nDbTx
	lLB3oh8pdb8/ulmuz334EMm0xzapQVjPsc+in/e9fpQdTRr7myUpGik5KkVL1iGwFdU=
X-Gm-Gg: AZuq6aIpzbkJcwVp73kGhk3Zih7KV/pNcWhl5vFJxACrnEerP9iVNcrNkATokAdwIm/
	CUjs+Lct92/Ys9KyenZSte8aa2FvPzYPwu2dGorMIgwqhZbT/2HTGmGCQC/PUPItKvjhApGw8nY
	97lomIjc7nKzSt7GcX5zEV+R/W7AZM4dEzgxE8Ga7E+Zb7BiLonZhF0zkcag9OhuVqA/M1UVjhf
	TrOO8xcZF70i2tHunTyOC566D5GKJvsJ1icnZOXZ22bfZTdtqZEt8IemJOnjEpP7SlcDsSHHpx2
	y01avOGF+P2ohFD/0Yd2Df1e4z8T8JHbQc7+UXufnAxxOxD1ULE8/hUiXWIaZTYgkdD/MqUulGO
	XHr0D+Yhq9Tk3DoWv0mwgqE2ftb/nbyCWRbbVSWDxGf9AOWAcAcKOjnHmBJ2f4X6udYzzF7+1OJ
	wg4PmXZ3bh09wdExHlwm0=
X-Received: by 2002:a5d:5d13:0:b0:432:851d:35ef with SMTP id ffacd0b85a97d-4362937dd22mr3165723f8f.42.1770369855926;
        Fri, 06 Feb 2026 01:24:15 -0800 (PST)
Received: from FV6GYCPJ69 ([85.163.81.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-436296b25d5sm4583939f8f.2.2026.02.06.01.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 01:24:15 -0800 (PST)
Date: Fri, 6 Feb 2026 10:24:13 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>, Shuah Khan <shuah@kernel.org>, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Moshe Shemesh <moshe@nvidia.com>, Shay Drori <shayd@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next V2 0/7] devlink: add per-port resource support
Message-ID: <7rmcwov5zbu4blljlnwfzhobmmjsitih3t7w7vabpmkigat6du@erprfflwyiqx>
References: <20260205142833.1727929-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205142833.1727929-1-tariqt@nvidia.com>

Thu, Feb 05, 2026 at 03:28:26PM +0100, tariqt@nvidia.com wrote:
>Hi,
>
>This series adds devlink per-port resource support.
>See detailed description by Or below [1].
>
>Regards,
>Tariq
>
>[1]
>Currently, devlink resources are only available at the device level.
>However, some resources are inherently per-port, such as the maximum
>number of subfunctions (SFs) that can be created on a specific PF port.
>This limitation prevents user space from obtaining accurate per-port
>capacity information.
>This series adds infrastructure for per-port resources in devlink core
>and implements it in the mlx5 driver to expose the max_SFs resource on
>PF devlink ports.
>
>Patch #1 refactors resource functions to be generic
>Patch #2 adds port-level resource registration functions
>Patch #3 adds port resource netlink command
>Patch #4 registers SF resource on PF port representor in mlx5
>Patch #5 adds port resource registration to netdevsim for testing
>Patch #6 adds selftest for devlink port resources
>Patch #7 adds documentation for port-level resources

Could you add dumpit op for the current devlink resource? I think that
was indented originally. Will help to see the whole code-picture :)

Thanks!
