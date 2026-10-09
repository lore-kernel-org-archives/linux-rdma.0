Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423964EB849;
	Fri,  9 Oct 2026 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556914; cv=none; b=RnKfhC1mGUTI98zFykgsF6hILVQYogX0rys7rHne4KAHEtcSgyt38GR1IlUbXyWnZ8GVgkpQjt+njeFAIbz5DBVUQgEugiMIHjEWpGTwBNdkfMCOF/U0V6jVSwsDL6Y0MOtjmPUbwZe5B6iiqyQePj95GDQQQkBbYXswDEDSuIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556914; c=relaxed/simple;
	bh=QAZRfkhwUOKIayfvhgYn80RfS7ClFFfioZkHfQhBQ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSC5MiFJZuukuT5eb0zOhGilpJ23NssnwFoWQ3OwWdYm6sxY8SWc3WOHbM0O/SMVbaTdG+eSk0quk1r9OTFnAZwMoM/IA7BipwUupoPVatC36IcT9Nzj8M8mUxSu5yQUh5DW0ezUKis5ZB9XvY3z5m80+9Dbc1YsmtVQhm3rkBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ACTLqvfP; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ACTLqvfP"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id D1DB120B716A;
	Fri,  9 Oct 2026 07:41:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D1DB120B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556911;
	bh=yfVfqFOqfTRHnQCrt3r9MWrleaEPL43wlaANsktd1jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACTLqvfPzAsdE5ddnSRrXTaM5/sFakDZNJ5wDRkfuCrcYyWyLa4asLyJtUjMKtXyb
	 AkTnqDWjp5Ra1L1kqFSji0Q/rlvTomvuQ0jezOG33O89fimSpVZMxk3z+LgKJ90RY9
	 3Z0rTGdxZX98NZRnpzDxrRYU2YGLpeMD6DG097mg=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dipayanroy@linux.microsoft.com,
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com
Subject: [PATCH net-next v6 09/13] net: mana: do not bail out of mana_detach on dealloc failure
Date: Fri,  9 Oct 2026 14:41:20 +0000
Message-ID: <8c515f9f2d4b6db7a29d69ebb53fe18c6c751caf.1790795005.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

Remove the early return after mana_dealloc_queues() so detach continues
its device and port-context cleanup.

The return is currently unreachable: mana_dealloc_queues() only rejects
an up port, and mana_detach() clears port_is_up before calling it. This
is a robustness cleanup, not a fix for a reachable reset failure.

Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 51f9bfc64c6b..9297ce15efce 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -4537,10 +4537,8 @@ int mana_detach(struct net_device *ndev, bool from_close)
 
 	if (apc->port_st_save) {
 		err = mana_dealloc_queues(ndev);
-		if (err) {
+		if (err)
 			netdev_err(ndev, "%s failed to deallocate queues: %d\n", __func__, err);
-			return err;
-		}
 	}
 
 	if (!from_close) {
