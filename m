Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738382BCF46
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 00:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786322705; cv=none; b=CmzBBFwGmKofMJHF6J9nAniqHQ83Nnfba9ty1n4bS/xNTWy5iuA9kjAHR1ZHXM8XYhp2YoxmhewZ6Jut5o95Ky34DaWmx71tKSJl8Yg0dntk3r7vj0PaScM4JHhel4ykUwPDLZDo5vj3rTNvABqfxkHY8MWsUyaA8XIITpcIoiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786322705; c=relaxed/simple;
	bh=zs5KlPUF5+PEBm6bPaJehvWy5zgNIPqnxUabhFQYD3w=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=JLnKXGtEugAZosgF4lpDqerfaqjmL6VUiLzNRhNKEGcsBXjFTDutqaA5t/lOXrvJvfVEfXKHIvtcsu0X5cXwP4D32n9Zgt0lKQa6H5yYclozH0HCVWAJpLVzMqCVandykhLiUyKca+CMR+HEA8B6yW+01BaMp4+VV1THYy+tTvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a416619e8dso2506367b6e.1
        for <linux-rdma@vger.kernel.org>; Sun, 09 Aug 2026 17:45:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786322701; x=1786927501;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=y+ozQsBenqRzuDht0DO/9bS4hb5OlW+zXduxdenQwH4=;
        b=g/r2lMllrIEaM4qr9nxBevW5YrJkz2bYMn0qhjwuOxteuNNZeoxHjU6/IEuh9q0CM7
         B/HZLqBtZjOw1WBloCmE4xC9uw/NERwr/nlYrzu86MKHhb+P7HCIFI3cN16Hlrd1c6N8
         fZQUKvNEWjD/35QQaqYlmXCRrhaUF5e+QLbdf7PU1Ys9rxFCrABDCYMULRY2wH14xTCT
         LoZRmB1kndoYPvjnwn1UEmgB4iKoomiNlrQWZYEySj4sfr2k5T/KHwxzVgTRzmkVEQKv
         TGayAfFBDeLUOQBiyVlZDUyBzR+oYBYjMBbvZngbc12oJMhj8F21gM/SIEY2H/5Pq/WS
         LvGQ==
X-Forwarded-Encrypted: i=1; AHgh+RrcZGoTuQHMEjBJv/FxInJ9yUWhaksDqE3373rAT/Co46TlUCht8m2KT9bCHwO/MOlzBPCUCWKoOmn3@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr1cGElbDgeRERKnGE6FpSp0+90gmQCEY+dM/0KP4IOVg+G/UK
	W5FgI7oelfrDzCmJW8owheW3/bUS4+sMLiBf7DNm1SpbpIdVNEWo+34PXec9XLhQNnz6yURtjPI
	CRSCygaAnKbur7y+UEFMwiDo4WoGkEzVZH8hX1IXSIVlrqdZLcXVgoepYNGs=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c169:b0:492:7abc:422e with SMTP id
 5614622812f47-4b1af8d770fmr8656742b6e.13.1786322701486; Sun, 09 Aug 2026
 17:45:01 -0700 (PDT)
Date: Sun, 09 Aug 2026 17:45:01 -0700
In-Reply-To: <fee053e9-35ac-486a-b72f-d6539f16ffae@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a791f0d.9c11d2ce.289b96.00e5.GAE@google.com>
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

commit:         18e617ee RDMA: Check if device NULL before using
git tree:       https://github.com/zhuyj/linux.git warning_res_to_rt
console output: https://syzkaller.appspot.com/x/log.txt?x=1299dfb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d343b54cc50df0f
dashboard link: https://syzkaller.appspot.com/bug?extid=72eddfbadda3e3928e72
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
