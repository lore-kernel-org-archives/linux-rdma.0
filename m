Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED6B3B7757
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 23:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786404906; cv=none; b=Saq3Xelk7AGTIrRk21DR/vYhAk+6j8n2eMEJXSI2iC6nLoQwbRQTQ2QADsRWsPZPsU9z2vkg6FA/UjjqufO97oZhXgB/XmEmopR06PNjWaJt8cqF9UZs66/cxrS2A9IOERk8XdfZJ3oOM1CHeTuhz8MbxrtV1J0mRNrpY7ICnwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786404906; c=relaxed/simple;
	bh=zZEPobonppBkLqT/B7rUh78mhZK6P6WSf3r9VzaHocM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=P9kgjD7xoCuS2PhH+v8sQuyMhSLeRB+IDe2BKwrrkwdSo5zwR2B0TM+FJx3VtMp5fN+UHSFEV4pGC91dp+067nRlgrSwOp6FyE1PXM/I96J+9S91M+n8kfWI4YLAl7EjrsZdh7TVbcI3LDU0DObYaXk1b8d6ukXTT9VuExUsSx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a7de733fa9so3139401b6e.3
        for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 16:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786404903; x=1787009703;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ehz5AmGgOvZtG+EkGP05O47LfY/56oZQm2iWLUg8gkw=;
        b=diCPAooGjbO9kR8JH42Sh991JfjNjOaTfSlKAcdpn57YlWMT6GZoMQDx0VuzK36AMJ
         uJi8AM4luFP44UsUiqAVWGtef+Kmrho3GIJIb2Bvwoy21aS0QHa/hRqphHL4mNa1T/EZ
         2k80KEVEe+eDg+Fcue1WantlqTLPQck3P3DzQllPpSzuc7Uxy8DzUakdl94qvPtmQsJ/
         KxWiULDFwr/JLqWM9sBsM/QqGK03PueksJw9goWH1Wcg6mWFjR3VYQ8NBMNzuWvQEGt4
         Oir/eoQ90FtmFVU4OJYwyJ0/3S6E/GNiu2/LUM683Gz3XYkJ88igCC+/HyjFLlnJ/uQx
         ERdw==
X-Forwarded-Encrypted: i=1; AHgh+Ro8oAWGP8yDkzOY80wfuBNlEalU+29B8NMwrr+zorrwlni2LnNxIvoaHmrZmnzDkKuHVV9ujy8DKwk9@vger.kernel.org
X-Gm-Message-State: AOJu0YyTVukVQXbBMGa9J7f0Y7S1GlqEKoUxPeJNHd4Oy46oeBjYy7F6
	Zo3j/Rlvtn9aWSxKGCQsmkOi26McaHoj45X6e7jemsF42XCGfcNc4227Nz1z4mcEqwb9ucgA2N8
	XI/oPxd1bRkHpcTjZUDarA/BBzC0HmI8cLk4emGBCqYuwSwevfZqPU6rjncQ=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c3f3:b0:495:feaa:9e39 with SMTP id
 5614622812f47-4b1e7732b1cmr2807249b6e.6.1786404903426; Mon, 10 Aug 2026
 16:35:03 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:35:03 -0700
In-Reply-To: <e1b573dc-8b98-47c0-a997-c4f0cc3f926e@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7a6027.01d0871a.3a0d52.00b0.GAE@google.com>
Subject: Re: [syzbot] [rdma?] WARNING in res_to_rt
From: syzbot <syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com>
To: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	yanjun.zhu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
Tested-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com

Tested on:

commit:         8b1a07ae RDMA/cma: Fix WARNING in res_to_rt
git tree:       https://github.com/zhuyj/linux.git warning_res_to_rt
console output: https://syzkaller.appspot.com/x/log.txt?x=163da149580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d343b54cc50df0f
dashboard link: https://syzkaller.appspot.com/bug?extid=72eddfbadda3e3928e72
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
