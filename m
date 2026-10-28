Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228049;
	b=HX7/VsNMHwdMqoiKOxrD5he58mkdW0Sb93561dOlQ6VZvx3NnmrwVA/n0x3BKX79u6Xj
	 fY7BRrzI13FTjBIh+zFI0dxGyYXimTCH3Two5nyZ286Jd4EjoZKbQEGfVdnLaiiyNYP2A
	 jfsU2mAZ1tr8BEH0Sz2gF7PbRUW27/UwAWM81fRjwDlPpydRxqhZN1t1MUgERjKak4++x
	 ef9xXUkSgSN2hfegzYR68WGjxI6U1PsZYuTscIxEpqAz1DmuQ3+e1gJXnpouGgu0EGUgf
	 5WXcA8IbHZw9hF2sMpA4461TqDvykZfohma5+0V3sE+t8Em/C6hgVaFFCYwsmMofPKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228049;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=ewzOlCxIxYO8JaL09AMv8VOwrO4YcTFDskoxEdLhuVw=;
	b=Kiu3nFL76MCXyMW6IfzbouSUtSX/bv53bRslfb4yrR6TzHwh6VpqbxrFSTfMNkaPHnGc
	 lDGQfbJRpnQZ72L8nZuuScaRY0YMYlVECpqWK4Xeo1Q8BauW9wqP2iYNYHX460yrYWMZC
	 rXREAEE5GZk9DywxSiYsRciGKEpFNa6VNVXYDRr6zU/jubHj2cbrSM0ISf/HwEyC/oCGy
	 jie3IKC0mmYyGsVKtlZPGtW1jXdgSYU9JlwHW1l+jVmyGQrIQVtyu8ftUCXU4eS4pDyOQ
	 N1z5z1oSg9hpFwLoQ5c7bK6tsRi4hWCDkAz/3PruR6Qjadl89btefxbsNmzMdglVoZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gB+QZqg3;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sx8rZElQ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gB+QZqg3;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sx8rZElQ;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3707B606A31A;
	Wed, 28 Oct 2026 22:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3707B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gB+QZqg3;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sx8rZElQ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gB+QZqg3;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sx8rZElQ
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 68A09222FA;
	Wed, 28 Oct 2026 22:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793228046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ewzOlCxIxYO8JaL09AMv8VOwrO4YcTFDskoxEdLhuVw=;
	b=gB+QZqg3mmc5n5n94f/GsLSN2ouzslfRXjYjSeCQxUOeT+fyysVSq5aYrp4EJTdDGmxPk1
	4fYIrrvs8PhYWshWB4bNxojjLzHLpmrd4zyItDB2drqEO+wC/V4zj174JRkgxSd0LLehcf
	vqOpmgYR1i3I6u/GliVfhpOk1MXJuOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793228046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ewzOlCxIxYO8JaL09AMv8VOwrO4YcTFDskoxEdLhuVw=;
	b=sx8rZElQI6dPYRRYPDnfSlEMv565Rk/yk4rglI8eG8/Rz0VeNEiUKhhZ0KhPDpyLfV0nuV
	jW51y5zPXnJvOnAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793228046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ewzOlCxIxYO8JaL09AMv8VOwrO4YcTFDskoxEdLhuVw=;
	b=gB+QZqg3mmc5n5n94f/GsLSN2ouzslfRXjYjSeCQxUOeT+fyysVSq5aYrp4EJTdDGmxPk1
	4fYIrrvs8PhYWshWB4bNxojjLzHLpmrd4zyItDB2drqEO+wC/V4zj174JRkgxSd0LLehcf
	vqOpmgYR1i3I6u/GliVfhpOk1MXJuOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793228046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ewzOlCxIxYO8JaL09AMv8VOwrO4YcTFDskoxEdLhuVw=;
	b=sx8rZElQI6dPYRRYPDnfSlEMv565Rk/yk4rglI8eG8/Rz0VeNEiUKhhZ0KhPDpyLfV0nuV
	jW51y5zPXnJvOnAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 723D013419;
	Wed, 28 Oct 2026 22:54:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f3sKEQ194mqHfwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 28 Oct 2026 22:54:05 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netdev@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	jaka@linux.ibm.com,
	horms@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org,
	edumazet@kernel.org,
	davem@davemloft.net,
	guwen@linux.alibaba.com,
	tonylu@linux.alibaba.com,
	mjambigi@linux.ibm.com,
	sidraya@linux.ibm.com,
	dust.li@linux.alibaba.com,
	alibuda@linux.alibaba.com,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH net] net/smc: fix limit_smc_hs sysctl on big-endian architecture
Date: Wed, 28 Oct 2026 23:53:50 +0100
Message-ID: <20261028225350.3753-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

net->smc.limit_smc_hs is a bool, but its sysctl entry uses
proc_dointvec_minmax() with .maxlen = sizeof(int), so the handler
accesses four bytes at the address of a one-byte field.

On little-endian this works with the extra bytes being written in struct
padding. On big-endian (tested on s390x) the bool sits at the most
significant byte of the int therefore the bool stays false and the "1"
goes into padding. The sysctl reads back 1 but SMC sockets created
afterwards see limit_smc_hs as disabled.

Fix this by using proc_dobool() handler and adjust the maxlen to the
right value.

Fixes: f8406a2fd279 ("net/smc: add sysctl for smc_limit_hs")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
Note: After reviewing another patch fixing sysctls, I decided to
review more of them and found this. I have tested the fix on a s390x
system.
---
 net/smc/smc_sysctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index 09dad48337f6..f58cf256f61a 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -160,11 +160,9 @@ static const struct ctl_table smc_table[] = {
 	{
 		.procname	= "limit_smc_hs",
 		.data		= &init_net.smc.limit_smc_hs,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(bool),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.proc_handler	= proc_dobool,
 	},
 	{
 		.procname	= "smcr_max_send_wr",
-- 
2.56.0

