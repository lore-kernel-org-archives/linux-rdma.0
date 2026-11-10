Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283262;
	b=4kPTHYWLqDKNeSMunvmf23DkrKCyufEsPA/NCMJSNIn8WhWX0w2Dox1EdRwfdffsvsg0
	 mrN9g3jarbPIjmTdXRpNaw2OzUT4Yhzux3lO1KAddJrL6UPFunlHWfVq/fj/W446sUAj0
	 yevl4SF01bdldF7O2FjOm4S8QGyKaUQFNhPIvAwA78ZH5qPL6i6JxUK+JpC4kDWMsuIUe
	 i9B4jwneLzpW1EIuE1H2lNqUyNRrMFTTY+ciYM9gyFGcKjWlclBcIbaoMuost25BmG4ur
	 3k7o4P7xldnuI2/xtRZeU4o5YQNyS6tZsGia+lgLFnfYsj/t7flWpNkI4ndmJ10nBPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283262;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Fc5CdWBwO8rcgwhyScbTRfwqKZ+h1qXiMpL8rILrgjs=;
	b=dBnMGutWp8VU/OZoCrqVgDdu+ViSEfrb8TvFBl89wkcZyPiJgVl2qvKWYAYjVUvMhAIp
	 QYMig1Gf4+R/A6mG6LjYGob77Tq8SMfI27R7zh2F/3VpC060GIix4+pMf4mrrH0X1QkUI
	 RDyGMxY5sAjqU3elBs3GEuEKlyZ+rVN0SmgqBoYBzyJ+DbWC+SYXuEiKz4RMfH0ncHNAr
	 RGBavMIR08K4OELdrZzUsX/CfS8Jp97pKAmrB/ULN5Hxpg7z0Zw4OmFMYtvZeqnF5iSPT
	 ICEJXE2UP6lD2gBqgmwxUf75L8bSC7F5nmUDrQEeLqh1eXWqc3TT4hT7RIxkMvaOJbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeDh9gsT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2EA60A2623;
	Tue, 10 Nov 2026 04:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeDh9gsT
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794283262;
	b=k+AGssrZEPTASlgCHaIgX4FtDuDHYRJi0evfv4CqdAsxMmxadeJndUVh6hLZCRlgGdPZ
	 aV9OG2BNHa9LbIEJ+lDxaR+uI15uai8pxX0OYw5AlTnGWxNl6GCYKiA7IoH2dvbIOrfI8
	 bnDs6TKDitJOJ0pQvNbyKuvT6qfZLqcq169hRl5uhguCsWPZpX3QrI2R7Jh1ni8n7vMy5
	 ZbN0cT0srbCrpuXw6uNxScTguvPtcKA2WzbgJrOZPwrl8/YIftFjI4Qu4c5spltaWsaUL
	 Iwqb8ZxkFMNm40Pp10YlTSiCnNfRtr8A/EAo0PIDO+kjTN7RIglfWJY+LrVQM+tduJA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794283262;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Fc5CdWBwO8rcgwhyScbTRfwqKZ+h1qXiMpL8rILrgjs=;
	b=IeWNkP7rNhrdW2KBp/Jq3lWm94Er9zdAzIYp9idn0jod4yfXcrmuecgu+sIUkEr3G2Mw
	 N/IhmNCR9DiUXIPm116bgLTNhVRVk0qRuRuuosDkt410QG13u8B8SIM6js6uENwxKPdmP
	 kD21jiGWn4kivrY5JHrjcU2rZ4K/hmK8xLyeyBh8jmadh0sCKiV+2HxnBCT72qE4om1xf
	 Qlz46M2z+u7gndRzfmbOOCMRNwtExQN5aTJoo0bug8IZRwP3oTZ0mEIobmbsfddvbxrNQ
	 niJ2Tfi+XJJF7zdifpOWUKzpSdRA+nBZw7gSeYMn+KWTHcCOSwNEyiOrhcFkxhVtdOw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 03C571F008BD;
	Tue, 10 Nov 2026 04:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283262;
	bh=Fc5CdWBwO8rcgwhyScbTRfwqKZ+h1qXiMpL8rILrgjs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=CeDh9gsTIMFyFPyHhAlFbkZrdkRM1Dqx+3gx7BCWhicYcYARyCBw3QhkPJpRBEf1X
	 jjMs2aNwksac2T2naqRDq/O+OtHa+KIknv3wfs/Ekxi8mS3uDYnClCtwhMW8QjiSWD
	 4W4xAXgU/ZWqAvJfluuiVLOFVVCM0MQOdfpAi4Hm5FnVo4wrqZec+/l/OWEKK/rdi/
	 IvHMOXoElGR7HrXNuPWiQBXsLC3T/lbdX++kUF/9vcyNV6Sr6S+Acz414oCqCfauoq
	 +nd3gDGA4WFYq1JpFBK1u44M3mlAQt6cVCQflH0jqg9iXSxPsM4BNUGQ+sCHzf9RJ6
	 o2QHC5sG6YmXQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 817DD487FA;
	Tue, 10 Nov 2026 04:00:51 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 09 Nov 2026 20:00:34 -0800
Subject: [PATCH rdma-next v3 01/13] RDMA/core: widen the uverbs object key
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261109-uet-ib-core-v3-1-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
In-Reply-To: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794283250; l=1286;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=u+nXPfZ0LmyAEAoR1U+2+X3qtGAMbzz65HSY7TilY5Q=;
 b=bHYxjlj+/59loJyAi9T22qMZUnYDem+lB39Z/CmoeRe2ng+ZwL8FJqmAua1x92gfdtI6nGR3I
 dYVfGrtWy+qCUqx3LcwYM5My7gHgZ/3wv9qcs3RsatF8vVzEl9NZpvs
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

Three more core objects would leave drivers nine object keys, and mlx5
alone uses ten. Add a bit to the object key.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 include/rdma/uverbs_ioctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 1aaaadb8daf6..a920e57ce990 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -108,7 +108,7 @@ struct uverbs_attr_spec {
  *  object_id, attr_id, method_id
  *
  * Which is a 48 bit value, with most of the bits guaranteed to be zero. Based
- * on the current kernel support this is compressed into 16 bit key for the
+ * on the current kernel support this is compressed into 17 bit key for the
  * radix tree. Since this compression is entirely internal to the kernel the
  * below limits can be revised if the kernel gains additional data.
  *
@@ -144,7 +144,7 @@ enum uapi_radix_data {
 		UVERBS_API_METHOD_KEY_BITS + UVERBS_API_METHOD_KEY_SHIFT - 1,
 		UVERBS_API_METHOD_KEY_SHIFT),
 
-	UVERBS_API_OBJ_KEY_BITS = 5,
+	UVERBS_API_OBJ_KEY_BITS = 6,
 	UVERBS_API_OBJ_KEY_SHIFT =
 		UVERBS_API_METHOD_KEY_BITS + UVERBS_API_METHOD_KEY_SHIFT,
 	UVERBS_API_OBJ_KEY_NUM_CORE = 20,

-- 
2.56.0


