Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793965073;
	b=qd6ZYUXiQhRz6z6fDqVp4QPOQcnl4igBooZ31yt7Sz9J5hnFrHoVSjR7N9i9hL2yGKq2
	 r+2yE/V2aQmTxCBi3GD88YafzmeeW5UUPrsot7im7VGo8GsZBYufP7T8Eo2P9RbmqCDi2
	 oVqj+44evcR/tt2gjX3S/mOveB3SpAqSsIo6dZhC0w2yzvzDMKATlmp7KefnClIbEDdAt
	 Uw2SnVPhmAfAv53vr/UPnoL10DciB8PSLpBd5PyFAtHfjhJkx4Vss3mUMjA752oNv96XH
	 1OssRPuncIAR/JftkKbqYOzbxvEL029w4BNgS2EGdUgfyuchbZ4GHIL9SdTWVJsDthA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793965073;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nk/cwVUI+HhtrpE9+By8yGGW1zgCdHKuqXC1z6SrQpw=;
	b=4eOKBB5Q3pWDfEYapUd2yEt16Qp1BmlxK0racZeYd+3OpXRYzolVQa+KF0f7JRVERli6
	 aqvf8I2aUAIwcrWvP/E7u+ZI71AYRIDDKRoT+zUVyEl6ISjq2LkHDbfUuxDlIPWQ0tK84
	 V1ZxzokxydPd9iPZkt1Zk08B5FC5YzDOH3O5wQ5tdr/6cmwbwYlgXdudMJ7QCqja6mzgE
	 ngIvGjEZd7Q60twkJBg2rJJpUOOOv5kwGm0pe6uAA3/K62AK/d4iSw2z+Ql2oOP0au1fg
	 zBM9coeECe2u9o8c4JkUcTVnnee7IVhzF+jdKyB7T+JPLr19KZowMlIKjHoJkVXL7QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF877606A33C
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 11:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF877606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1ae18eb9ad0so735061c88.1
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 03:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793965067; x=1794569867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nk/cwVUI+HhtrpE9+By8yGGW1zgCdHKuqXC1z6SrQpw=;
        b=e0rnDNCCP/vEzSNMrsvM7E2F7XnN79sZ4lA7f2scoMSld3YqrX2kvu7bGUzammNRwk
         FZ2qB79S8KuD5vM3UVIrU6cd+wdYWfzLE+/ealF8EMr6U1Lw/X3ebsPL4vQOmuvFObpC
         9hxf3QdT6lK59b4jvXcEa+KdEi7CkXag2rYcLs6dwhebdkdII+xVQN/yXq2EHh9dAUja
         Ll/iHDCa5c5E91jsTTV6OGcI8ziKHFmMHDlrIjp4CjLFur6OvmR8kgkdNeuRScRxa3Wr
         NLF9FjDs4hp68IdIdH0/PD61Emgy8bhx5wosAPos6d4snA2+2aB7w0Lkp3psUMeMIU7o
         y6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793965067; x=1794569867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nk/cwVUI+HhtrpE9+By8yGGW1zgCdHKuqXC1z6SrQpw=;
        b=ixUXDRT0/BTSPzcDPRimvqAZG3q2S7uICh2fh0LiRI9DQfXuFTrO/YrZYkkANUj/v8
         P5V1rUfw3RW3t52sBQlv7zXIvjq3OL14pz4ojC3J/ZRjFdUTLuNe0uzT9GNjPjZyLCIv
         JUjuld6Bs49y8676yjpCl1Tmio8USfqA9bsi8eyFSCFhZJN7h00Mq8y5C5E/ysBXC9ZY
         U4rHYS4UQVTQ1L12VWrxo1Ru8wt3yg5sZsMQLR7hHR/YqjMZp0zC43wPUtx94cNobV8G
         q7Cbelb00qjrBeQsz1UXtxWvZaMoWrzZy6nifYOt+558X6Zl1EqBG7qc7jS+nAv/87/f
         mI5A==
X-Gm-Message-State: APuU4Z/3zW72wC+U2vUP1KmCnALkefworLc2mMOLLzxG+aF0jX+6ee00
	DuPXcfvl6dqKKTEpSYroWXqbfkp3y5qe/c+ALWDVaDU0HWOzaSGh57nJNCwJltAM1sA/pdB5PvT
	aaSsaDfU=
X-Gm-Gg: AYBFou06pk2x+iommfLiijYMd03JMWdrI2ZEZHMwn7bxn0AcbpGAu826Ts2Mwud6cPr
	0L7dLLJtyhL7vL5Iyf01o/3J+DqrHejQ8TVM33mG8hrf7UQF6zQIlbOaia3FUErwsOOuKdd2466
	wtCdB0l6thoe74GfbwDvfnKfFodlvgcIDCG6AtW0eQNS54hkWi797ZHYv2r10jx7Lqg7iu4Ul62
	PLojfRbm4zsP5cw3SBQ2Gz4vp2ug9nL6SXuu1C47SHqHXWyNadWC2fr5pj8dRaSYc2uTHOaGYMR
	CSypjGqM30srRCpbmipEC/AziJz578PJLDUpK+kwlRTz6rfTB/XJg+4uO9jcvjYzWlp7OqKq1aA
	s2PBOFKR3+5fOVoOZTQBFwCIc7uBraqxxD8q9NpR935RcVe/ge8uul+YCS2WwpGUDGGC5u5vn8i
	LwiqyLZTJeSZY/YC5wnuCi9CyopNG9rMK1g4R3Vcwvwq6oNBMK2uHdNjJYGquzeO03jG7FVUV85
	IDtlX4aRsstp5AtkFrqCJMp1H8HWI7fGKLD7Ym9eljsHfgIWdkcHWHikhYyAVZzwTM2M3R3BS+n
	WS15hL6urRTTvz7J4oczTPD+OLK8DvOjZ6NjacAvBc4+4w9CSkgKwKpUZ4cO4rKkocABWUaz6Np
	ALzI6lweE+mk9d5TpNRefKcLYTYszpBI1LuSVDw==
X-Received: by 2002:a05:7022:7f04:b0:1a9:cad6:5b58 with SMTP id a92af1059eb24-1b25d3650f3mr2994163c88.39.1793965066505;
        Fri, 06 Nov 2026 03:37:46 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:7bac:856c:1494:b5cd])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e261962sm8107687c88.0.2026.11.06.03.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 03:37:46 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-rdma@vger.kernel.org
Cc: target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] IB/isert: fix the device removal use-after-free
Date: Fri,  6 Nov 2026 20:37:38 +0900
Message-ID: <20261106113738.2063585-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104142043.GG478286@unreal>
References: <20261104142043.GG478286@unreal>
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

Hi Leon,

Sorry for the flood of versions. I should have waited for review instead
of reposting every time the bot flagged something. I'll stop here and
won't send another version unless someone asks for one.

For what it's worth, each version was tested on soft-RoCE with KASAN,
racing device removal against connect, login and teardown. I don't have
iSER hardware, so none of it has run on a real HCA.

If it helps, I can send 1/6 and 2/6 on their own, without the stable
tag, and leave the rest until someone can test it on hardware. If you'd
rather drop the series, that's fine too.

Best regards,
Yehyeong Lee
