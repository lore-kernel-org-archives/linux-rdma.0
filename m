Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793478814;
	b=U+06sSseQg+qgXrgpa5gaOBeVYzsXqs9Dar2FiHmk+v1qMpXH4oVYu09NUksiOBhwh3s
	 X12k+ttki1q1uCteySuCrxUym+PbfD8EnfAscjbpazuvAAjESW9MgGBk7fx87jjxP3hWV
	 NQhXKfdnzvKWEpcSIWuGZTdBFeMYE9oIHVLyEEU3GT64XnbPy/FgmYICc7xbInTygrfi9
	 hHnfLXejku0AYRNrThvuCwjXp0OYNNhhWURBp7JaxjKZ94kuQc9rpjIpVdDjx73KdI9Ia
	 x8fPUVdSiSMwQvqdeTuE0UCss/aajhp2iF4xSGiXGabfrR92ug7BmBVcNgX8juRzUXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793478814;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=68ZDKNjvBiemw66qi5bGSPjUFdtqvTif38QW77x1Uy4=;
	b=rJ151djbhD3jenxfYJbIyfKAT8hweeikiaDWZRkPdArKssscRaVUTJxWbFWYAxyhnQDD
	 8VuDBzQ0rMlRdHPaWbEsTCBys5ch8GzvaSNHkJgzAZfV/dL2P7pc7B3kugWi50b0B7J9m
	 oDFU7mqOoZ94c8hazwnO/tuwvkhXIK390BwgGiu8e5ExvK32rDVUKVJS7kKmMWM3d0ZBW
	 198iJ9fJHzunXjQiDjXn35rjZ9ZsvrncO+Vk5Y9NHH3/ucG92/Vxq5qV365hpWbzb8ldm
	 H19vhJZBKxHB7H4k8Dt27vDJiP+nPzd1isYeIEiXyA0Zzqg5Peve028l1ae0Qt09vuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.161.70
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12953606A31E
	for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 20:33:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12953606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6dcde9c2063so1923626eaf.3
        for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 13:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793478813; x=1794083613;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68ZDKNjvBiemw66qi5bGSPjUFdtqvTif38QW77x1Uy4=;
        b=fcJPHgjvkd2gjQCbzgowfkOvIThDvQHEh0h+ePOSKloeZhFS2uyvxEX2qDOmBmeyG3
         NpblF2O7CF1QbkJCoURaIn3LkT9paqQWPLQbNOfqj/Uj+YkwjgjEuqj6GG5xDCeL2eCj
         vOEz2KxdJnlDyrBUOdvpv16l2tlGzr0/7/tZjwIoOQ7PjabDxmwG1uJjk6Hwm6oWDf7U
         6InNIrALnKZnUkF2bTD7dfNugw1gSiftCMF7hE1V/MvuVA/h2MBhYvHrgaHMEWXOZv+d
         puCVehhIHg0sDUElLTxzDsbPCTvTZ9MFKirSho6wiYQU410Qo18OX5vXjLrFB1kJvEhk
         X8MQ==
X-Forwarded-Encrypted: i=1; AKwUvByju7/He4rKG3nq9Ih9jkHOHqUalViAENVcwdtEliZ4EzdlsKORkuQm2GKjbq/OXiAssWj7+eJBpLmj@vger.kernel.org
X-Gm-Message-State: AFq9FYItuT74j9btjTTAUOlBWgxZwYPifqKSK3JZeYmfYHFjRwzDvFtN
	ADtXE0a8QIdyv4CxOFzwWTggPQQHwds1kgkvWa+HuOomf6wzQqFNKeLwvhDFgNlc480MRFB7zLF
	4zZmRLpTXXnoQ/h/JMFwom7JSSjjLW+aCuA/5CWSVP2Hax2W5ftrkoMJVfnM=
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b27:b0:4f4:fc4e:77e9 with SMTP id
 5614622812f47-5640de136b1mr4077638b6e.42.1793478813014; Sat, 31 Oct 2026
 13:33:33 -0700 (PDT)
Date: Sat, 31 Oct 2026 13:33:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae6509c.64e51036.15cf6a.0000.GAE@google.com>
Subject: [syzbot] Monthly rdma report (Oct 2026)
From: syzbot <syzbot+list2e3a6666ee4387535ef6@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello rdma maintainers/developers,

This is a 31-day syzbot report for the rdma subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/rdma

During the period, 2 new issues were detected and 0 were fixed.
In total, 6 issues are still open and 76 have already been fixed.
There is also 1 low-priority issue.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 341     No    INFO: task hung in rdma_dev_exit_net (6)
                  https://syzkaller.appspot.com/bug?extid=3658758f38a2f0f062e7
<2> 215     Yes   INFO: task hung in add_one_compat_dev (3)
                  https://syzkaller.appspot.com/bug?extid=6dee15fdb0606ef7b6ba
<3> 3       No    KASAN: slab-use-after-free Read in debug_mutex_unlock
                  https://syzkaller.appspot.com/bug?extid=ae549381b4daac2895b1

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
