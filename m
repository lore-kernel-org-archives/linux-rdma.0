Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A517F2DEA75
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 19:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792266073; cv=none; b=TnmLu3HYOS0VkIQ8cR7aaey8NQ3JFaJphbz0K0kFY+POc8RJVSrMezLcJS7CEok0BryDKoJkmiddKOvJZDh7RoETi80PSk74r18F2HPyrA4r0bRZk0BsiuByFs5VLD8Ay2F0mEGNhomQ2tiJrjYki0lbF1zMCY1V3brr+pDkLUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792266073; c=relaxed/simple;
	bh=QPv+Z8vzX3VY5Sy1t/flRp1XN74GPkpxccCBZDK+Y7g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t4GEXIoHPgVXD8gz4sjWTjDQDDY6kOnkbEULIZy/DkG56o9CCo8kzL0rxh89wPf5BZMhmSukUHkk9vSVuTgQt/Qx8MERL0rNAbshF/G5SOswPXPsXQmKxvVRBNigJYucO7XzYGnRGxk4zLKp5Wg/LM9S4lxJ6P8W5+fpiYu8ymg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rSUfWYRX; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rSUfWYRX"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48b042c0728so185207f8f.1
        for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 12:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792266070; x=1792870870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7bkANSMhFloWtWtc/bd8b694jgoI0AgZf+f/ClS6h3w=;
        b=rSUfWYRXrQNmlcYPWOOI/ITjxrth8LiEmwZI3WbyV8LyC6gUxefT4QGk6hrY5N5vFe
         3HbzBNutoa34pO1p/oewrObEBUEP68fcAZ6BxWAS8WUxK6BpFkqXlFj/DPcqm0mJSN0A
         xW/ddMyGxrJD4W1u6Po9J/42MpNE9Mqn7hi6ybtjW8LsN9ywzQxJdGqrb8ybsRokFiJ0
         sU+Z2hEdAfNVbKHVydqISwzu07DbfQPLgy818LFlUCJknb+yd0wY5EYGLpWlY+Alp0Ik
         7y8zCVbOr8Fc1b9fp2xc6zoYA+gss+TarDspW1n7WH5EaP3gxrfE2Q8i72hg0+ncKqBi
         UT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792266070; x=1792870870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7bkANSMhFloWtWtc/bd8b694jgoI0AgZf+f/ClS6h3w=;
        b=SmL4Oi5UVPDTXqOIzSmmnnjzOsMASh8Je8vXJN6oSmAUz6WYuiqKMzKptMKQBd98XB
         LVMdpSwg3W3kqHjnJJANcqGitPrDAo69HSHn1kI5EgUotsug86d5tmYHD4ZjfBRthTd/
         l7jSXWEb4J6Qk0dCEm+s1T3Hx7ZgSYTEYOngNHH0mU29rDlAMVLuXx8WKMsJreR5FfhY
         y2c0PvGzVQPya794z3swZkahR9WBXqR3h0k5R1iJHFH6KLaP78iol9ilN3dN82d+RkIY
         QR3heMQdjOMsxnRLUSCCO3zLzH3EC8CKfrBd6A1O5HHcnEdMT2wmk+sUTR2BU0mUNcqk
         c7NQ==
X-Forwarded-Encrypted: i=1; AKwUvBxIUoMf3IPjbkko38zyxCcFRQk4pqhn7X+qKNWz8Pzkmk7jtX5XyZgJXhuVaQr+43WKUt9ZIpwy3dzw@vger.kernel.org
X-Gm-Message-State: AFq9FYJqx9LN9UwHZX53v+asebLFUtZEVLMX7lUEtSyf4UUqQkk9m5dX
	HhhrZp2eYa9Y33OCM6Jn8Jh2AsC6v8l02oN6alUwQS2fCrlDEksWLkWM
X-Gm-Gg: AYBFou0314G9RbeZBnrSDkDwSeg9aMbOqIhXe9bkfcrBS4E8cx39+Yjo86MdSDEC/9V
	VRV1ON7mqBzrWWzHQj+90W2TvQPr1ffIzdlc9iNIPBnePplMZ2DJNuxMhRf2JjoplcHvnLZyaKl
	4nWC0QZdPguK+Q16fYAEVabiRJVnjeLveKLWw+wtxqrBJBqB1pHi3tpBJzL3u/oxJyKlGdKFwVY
	9EGhpysPdAoVLt+IzBADazc62l1YqVAbz7990A6zGrdpLLgpQhzvwJz7wBT2v5ohIKb7bUPE2SA
	gq1A7dtggFzXAEtjVwmIOk9rZF72rKRqdganvN4Aav3OanhDTkmsbCtULtoyfvjPAIPHy0GXtFa
	tKGR55nU/+KJvEHYRfuIiwMtIwzVmK3WwMtGV69HRShQjUPeg73ySS1krdwYM/dLkLeZdrA4dq2
	sIp1Kqpp+woRvtN7nD8PeyIngl63Wn1O8jyCTFzSo0UGbpGZbILnPI9l6ReLL8WqOxk7uPfCZlr
	brBSmNuE7i4AXdGKNS5Ysfe8e9AbY6AaeAClzw=
X-Received: by 2002:a05:6000:260a:b0:486:f9ea:796f with SMTP id ffacd0b85a97d-48e07fa67d5mr6234193f8f.41.1792266069637;
        Sat, 17 Oct 2026 12:41:09 -0700 (PDT)
Received: from varodek-gpd-pocket-4.tailae96b8.ts.net ([2a04:ee41:108:fe4b:620d:dc44:b372:2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd5033a2sm12803462f8f.45.2026.10.17.12.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 12:41:08 -0700 (PDT)
From: Vaibhav Gupta <vaibhavgupta40@gmail.com>
To: Bjorn Helgaas <helgaas@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Bjorn Helgaas <bjorn@helgaas.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Vaibhav Gupta <vaibhavgupta40@gmail.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] net/mlx5: Use generic power management
Date: Sat, 17 Oct 2026 21:41:02 +0200
Message-ID: <20261017194104.2684-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch to the generic power management and remove the usage of legacy
(pci_driver) hooks.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5f28d906c35b..d8dba3328bb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2204,8 +2204,9 @@ static void shutdown(struct pci_dev *pdev)
 	mlx5_pci_disable_device(dev);
 }
 
-static int mlx5_suspend(struct pci_dev *pdev, pm_message_t state)
+static int mlx5_suspend(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
 	mlx5_unload_one(dev, true);
@@ -2213,13 +2214,16 @@ static int mlx5_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int mlx5_resume(struct pci_dev *pdev)
+static int mlx5_resume(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
 	return mlx5_load_one(dev, false);
 }
 
+static DEFINE_SIMPLE_DEV_PM_OPS(mlx5_pm_ops, mlx5_suspend, mlx5_resume);
+
 static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_CONNECTIB) },
 	{ PCI_VDEVICE(MELLANOX, 0x1012),
@@ -2281,8 +2285,7 @@ static struct pci_driver mlx5_core_driver = {
 	.id_table       = mlx5_core_pci_table,
 	.probe          = probe_one,
 	.remove         = remove_one,
-	.suspend        = mlx5_suspend,
-	.resume         = mlx5_resume,
+	.driver.pm      = pm_sleep_ptr(&mlx5_pm_ops),
 	.shutdown	= shutdown,
 	.err_handler	= &mlx5_err_handler,
 	.sriov_configure   = mlx5_core_sriov_configure,
-- 
2.56.0

