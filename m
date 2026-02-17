Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD113C2D;
	Tue, 17 Feb 2026 22:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771367512; cv=none; b=nxP0JDco6z/6j/FXy4CXl5YmZ48cQHxCFoAMKPsf1pTUhL3wu+5CCIg7L/emYNbznPTv+nDBij94xQm/VieRgjYa7IMcT0N5A9TXg8PpDSaf/IQ5bHCca3E98i+bhM3RJYgNuyIRHucuySuiK62bxSUmCgbf9ptpTaLblunZLxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771367512; c=relaxed/simple;
	bh=ahqf2qRVFegoMHQN9qWy0uSCWB+Tntxf3SSS1Kt/6WU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=W5GM836NlJdbMuhKpUv1Hjq/DTr++NvKPTzHvKucxsMxbHNBOnMSn+KwebTClA/z8YhcGS7fZTo0WUVTnI6GrvnisVlJfCYFQ7hzfAiGAnW9TFUL8saRZtg8o6sRhCTlRwQWwY7ESQYt1thT6fsN3NWjQGXpnLdM8BXyxPZzL3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxGvwWL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxGvwWL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D10C4CEF7;
	Tue, 17 Feb 2026 22:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771367511;
	bh=ahqf2qRVFegoMHQN9qWy0uSCWB+Tntxf3SSS1Kt/6WU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=TxGvwWL652Dx6J3RpAz9GbpYV+1fvUnwzIKZRpClPgqDAxVBOzREQysAOAbJUr5oL
	 u2VPALzb6d3HKb+8eHGMv8c1QF3un7xhsLERBe3PwgdKjVfjSysFNe9xld08LFKjCc
	 SnVcV+PXl7ok4mdlpVk0w5I8gXGQmKJdMi3VxjKSkimJj2htBfOy5KpL/TRqjnSO5m
	 MfPaCd7gfkr2xIneOwVlCJi148G84fNwNPHuCVjf+SiGws00Cr5ZV/5QAF4LNml9xe
	 4CU41PdtYSofaMkrGnMJZJq70T3wgt8oZF28TJ4os7t2+5AE6ZP9Aixz46RDb0Wa9u
	 YNJ9olGdRikkQ==
Message-ID: <01962d6e-7bb3-431d-9ec3-b4f20e883aae@kernel.org>
Date: Tue, 17 Feb 2026 23:31:47 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH RFC 09/10] driver core: make struct device_driver groups
 members contact arrays
From: Heiner Kallweit <hkall@kernel.org>
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: driver-core@lists.linux.dev,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, linux-rtc@vger.kernel.org
References: <5d0951ec-42c9-453f-9966-ecca593c4153@kernel.org>
Content-Language: en-US
In-Reply-To: <5d0951ec-42c9-453f-9966-ecca593c4153@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Constify the groups arrays, allowing to assign constant arrays.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/device/driver.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index bbc67ec513e..c882daaef01 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -114,8 +114,8 @@ struct device_driver {
 	void (*shutdown) (struct device *dev);
 	int (*suspend) (struct device *dev, pm_message_t state);
 	int (*resume) (struct device *dev);
-	const struct attribute_group **groups;
-	const struct attribute_group **dev_groups;
+	const struct attribute_group *const *groups;
+	const struct attribute_group *const *dev_groups;
 
 	const struct dev_pm_ops *pm;
 	void (*coredump) (struct device *dev);
-- 
2.53.0


