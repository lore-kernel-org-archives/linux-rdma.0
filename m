Received: from mail-yx2-f41.google.com (mail-yx2-f41.google.com [74.125.224.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4486735C6B2
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576657; cv=none; b=LaUKMj7tFYF/6Q9HbJefqbDjBttzjzLJMBe0+I2gvwB5IPBcWqdbTk8yORQQ4GM13PNFm0armeg6Rpr7JJCRgSa2qaYP5zVWjfaK5R6UT52u+36btSYBOW48W9hbyUwsfC9Zvqd1eZm/69L5rJJnE8uKokGRoAs4meb2N1Vwwdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576657; c=relaxed/simple;
	bh=Fuhci/NNQLVUzWkpUJ9YcTdRVY+06L73ZSAsWbc+3VE=;
	h=Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dXIeGElpjlM/SvIAOO1NyCv01Y4WFwDvFIbfKpt02UnuFS9FXWo2jZEeH0duCzMhjOjzcTdvrc/NJB4r7iw4yJQSH4NV3KZqiKrp4a7xLtDxvxh0WVzoaThdndQkaxw7gYkJn+MY/aZTWR4p9oys64hXHCl5XA4F6/xH1IL1J74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lwhbLYPl; arc=none smtp.client-ip=74.125.224.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwhbLYPl"
Received: by mail-yx2-f41.google.com with SMTP id 956f58d0204a3-6740dd8b4b0so2167451d50.2
        for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 23:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790576653; x=1791181453; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:date:message-id:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NgBUoAGMce0wDtJT/5tr5PejNWm/4KbKs95+kgenKk4=;
        b=lwhbLYPl64zWjoPjXWDqJSw4cdTJLhD/Nr/crQNjqiUD6XiCKfFeTIPvEXhCdZ0mre
         mFBx0rU9DBt9ioC07p3a9hsTI4CbrD1o+oAXQiTL2WspaDVX27vTfnFdTdRCtaT+hA+u
         4lk9nCkNZPgrCwFoZOAdsOLXea/Cb+gAyZyc9lyLJHQTS2AVEMwrIEwFvyIVY0flVUeR
         teo7bwE/oHbL/oENB1lSYFqVTHn9xRoNpUUVwemul0zUkBOyjr8Q/z7XixeaGOaGvXGe
         RY40FAhjeVnE6U2urvMol5gubOXBNwfLCGnIdB3AZfzM8qrol1haTXmuJplIAOW0CpGD
         w7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790576653; x=1791181453;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NgBUoAGMce0wDtJT/5tr5PejNWm/4KbKs95+kgenKk4=;
        b=xCjiUlx8QkS0yggkkNy8YREV1VWdMwrTpfkxg81tjv7td3LQ0k+knY3yxMSTuGAqY9
         NjxAG0zM+ayW1lQ2o+bduHrCY+kU7+1jHBy2aLLv2lFVBNVMDN8lFZPyGOQSfCyrBMZK
         9kEm1suQ/dFiPA1qAU0gIhldwt3OxohYBRUOqtHnLT6c8cXn8NpcDkOnQGOnMsyS9J/f
         5kOYiWE+b2VeSstQmvuhNtKfanbHomGTMZDq3HYGdcsJOfZ8HoSeXS1/Ogpolf7riOiC
         IczEQwXLGPGVM6zhr1a4nQYDwKCgGbnFUw87pMz5PE/SZynfbVPinYpYx05WyGf2Ht4t
         0WBA==
X-Forwarded-Encrypted: i=1; AKwUvBzCjvvd0wBFnk5QGi/Yv71XBhcRbwyoAhIZdgnnVLralUJzsZMBsPkjCiJktvAf2rSVLtUziE3HV3Tc@vger.kernel.org
X-Gm-Message-State: AFq9FYLQSXocmsyy2nPhlmsLqejnJpE9vCrCu/g6aQ8g6eRXB4hYLLcH
	zWoYrhwKhC7Hc4EQRRZgqo9guf1Af7+WYZAlYkdjzWD0WTaTlxiq+IuZ
X-Gm-Gg: AYBFou3V0jLSXJC6RbtPxc1xGoRRoqIxwwHDS2Gx4OjJeIZka2YbrzMKD6sWHWcRSKc
	5LXZFsTO+T/f7kSNF6POOrUT6n38dOmylrXT/JGnRo4x7qjDDjuQudbMi6tVAgUp93sYBQobDWG
	v1TacN1kg1ZflM+FIkY9dynM9G/qmCBaOKTIs56GqnX3gxkVnKCAHNu1j7DzdnEE59vYiurkrB9
	MxhoTSBfKYJ1FgbV8zT07ZZSpamAY5jC2DEBlAhLb/SEFgBt/gD+LZxHffpCSTfbSbsWLM3hhlc
	DlJ4VSG/f9EgVH0S6PFOnV6Ikt2iYKEGTOnQNV8Xy4QhsiQqTs402zUwEwOO924AKR36wGfLgFR
	RCLGHywQSILxmFqfBtfONP1yoAGnz+Dy/27HwppOg+A6m12Xp387YvIW/f8TCyQafC8peTI2lhf
	ubXo4/cXtlA9VtpWLc29oU0mmpFq06+AwoeHzrZ4dpGDc8mzVuToB025oe2XKHMCb+6taw22l77
	oQbnY4emayfft5OnBGq1iURNqnWNc1tgfb0kdJqkwmwxZgL81qG+TJZlGYK6ZzLnqZXmLTxOxla
	yvkTu6Z9aVfJZtJH1ACINyFOh05UMLEBt1jFlTr7eY8B6rALR/eZAc/23rEFmeov2g3Y+738r40
	E45BwLDZt4xkbnHBaUX+6d/yfxKW+uIBx5vu/VzFPTNkN39ZxGT6cl9X1q9g+bONQU4Oqi9CSE1
	g0fc2fW3AI+dj+1OPAThE8btUIZMUgHpGh7cAU
X-Received: by 2002:a05:690e:803:20b0:675:47ba:21b3 with SMTP id 956f58d0204a3-67547ba2609mr574124d50.103.1790576653226;
        Sun, 27 Sep 2026 23:24:13 -0700 (PDT)
Received: from [10.0.0.19] (c-73-137-217-102.hsd1.ga.comcast.net. [73.137.217.102])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86108f052sm39434077b3.49.2026.09.27.23.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 23:24:12 -0700 (PDT)
Message-ID: <6aba080c.b933486d.297b72.5042@mx.google.com>
Date: Sun, 27 Sep 2026 23:24:12 -0700 (PDT)
From: Atharva Vartak <atharva.a.vartak@gmail.com>
To: security@kernel.org
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 mjambigi@linux.ibm.com, sidraya@linux.ibm.com, w@1wt.eu,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net/smc: hold a reference on net_device returned by
 pnet_find_base_ndev()
In-Reply-To: <arn3qTu_SeM8Yrjj@1wt.eu>
References: <arn3qTu_SeM8Yrjj@1wt.eu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

pnet_find_base_ndev() resolves the base net_device for stacked devices
under RTNL, then drops the lock and returns the raw pointer without
taking a reference.  All three callers dereference the pointer after
RTNL has been released, creating a use-after-free window if the device
is concurrently unregistered.

Take dev_hold() before dropping RTNL and add the matching dev_put() in
every return path of the three callers:

  - smc_pnet_add_eth()
  - smc_pnet_find_roce_by_pnetid()
  - smc_pnet_find_ism_by_pnetid()

Fixes: 0afff91c6f5e ("net/smc: add pnetid support")
Fixes: 1619f770589a ("net/smc: add pnetid support for SMC-D and ISM")
Cc: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Dust Li <dust.li@linux.alibaba.com>
Cc: Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>
Cc: Wen Gu <guwen@linux.alibaba.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: linux-rdma@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Atharva Vartak <atharva.a.vartak@gmail.com>
---
Apologies for not Cc'ing the maintainers on the initial report, will
follow the process properly going forward.

Based on v7.3-rc5. Passes checkpatch and compiles cleanly.

 net/smc/smc_pnet.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index ff9c9c35c..d6e2f4454 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -367,8 +367,11 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnetta=
ble, struct net *net,
 	if (ndev) {
 		base_ndev =3D pnet_find_base_ndev(ndev);
 		if (!smc_pnetid_by_dev_port(base_ndev->dev.parent,
-					    base_ndev->dev_port, ndev_pnetid))
+					    base_ndev->dev_port, ndev_pnetid)) {
+			dev_put(base_ndev);
 			goto out_put;
+		}
+		dev_put(base_ndev);
 	}
=20
 	/* add a new netdev entry to the pnet table if there isn't one */
@@ -949,6 +952,8 @@ static struct net_device *pnet_find_base_ndev(struct net_=
device *ndev)
 {
 	rtnl_lock();
 	ndev =3D __pnet_find_base_ndev(ndev);
+	/* keep ndev alive after dropping RTNL, callers must dev_put() */
+	dev_hold(ndev);
 	rtnl_unlock();
 	return ndev;
 }
@@ -1094,8 +1099,10 @@ static void smc_pnet_find_roce_by_pnetid(struct net_de=
vice *ndev,
 	    smc_pnet_find_ndev_pnetid_by_table(base_ndev, ndev_pnetid) &&
 	    smc_pnet_find_ndev_pnetid_by_table(ndev, ndev_pnetid)) {
 		smc_pnet_find_rdma_dev(base_ndev, ini);
+		dev_put(base_ndev);
 		return; /* pnetid could not be determined */
 	}
+	dev_put(base_ndev);
 	_smc_pnet_find_roce_by_pnetid(ndev_pnetid, ini, NULL, net);
 }
=20
@@ -1108,8 +1115,10 @@ static void smc_pnet_find_ism_by_pnetid(struct net_dev=
ice *ndev,
 	ndev =3D pnet_find_base_ndev(ndev);
 	if (smc_pnetid_by_dev_port(ndev->dev.parent, ndev->dev_port,
 				   ndev_pnetid) &&
-	    smc_pnet_find_ndev_pnetid_by_table(ndev, ndev_pnetid))
+	    smc_pnet_find_ndev_pnetid_by_table(ndev, ndev_pnetid)) {
+		dev_put(ndev);
 		return; /* pnetid could not be determined */
+	}
=20
 	mutex_lock(&smcd_dev_list.mutex);
 	list_for_each_entry(ismdev, &smcd_dev_list.list, list) {
@@ -1123,6 +1132,7 @@ static void smc_pnet_find_ism_by_pnetid(struct net_devi=
ce *ndev,
 		}
 	}
 	mutex_unlock(&smcd_dev_list.mutex);
+	dev_put(ndev);
 }
=20
 /* PNET table analysis for a given sock:
--=20
2.54.0

