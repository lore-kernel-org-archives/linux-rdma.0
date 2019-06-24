From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [RFC][PATCH] wake_up_var() memory ordering
Date: Mon, 24 Jun 2019 18:50:12 +0200
Message-ID: <20190624165012.GH3436@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Paul McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Martin Brandenburg <martin-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>, linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Marshall <hubcap-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, devel-urhm25FSIHzptaDgeN77Px2eb7JE58TQ@public.gmane.org, Serge
List-Id: linux-rdma@vger.kernel.org

Hi all,

I tried using wake_up_var() today and accidentally noticed that it
didn't imply an smp_mb() and specifically requires it through
wake_up_bit() / waitqueue_active().

Now, wake_up_bit() doesn't imply the barrier because it is assumed to be
used with the atomic bitops API which either implies (test_and_clear) or
only needs smp_mb__after_atomic(), which is 'much' cheaper than an
unconditional smp_mb().

Still, while auditing all that, I found a whole bunch of things that
could be improved. There were missing barriers, superfluous barriers and
a whole bunch of sites that could use clear_and_wake_up_bit().

So this fixes all wake_up_bit() usage without actually changing
semantics of it (which are unfortunate but understandable). This does
however change the semantics of wake_up_var(); even though wake_up_var()
is most often used with atomics and then the additional smp_mb() is most
often superfluous :/

There isn't really a good option here, comments (other than I need to
split this up)?


---
 drivers/bluetooth/btmtksdio.c               |  5 +----
 drivers/bluetooth/btmtkuart.c               |  5 +----
 drivers/bluetooth/hci_mrvl.c                |  8 ++------
 drivers/gpu/drm/i915/i915_reset.c           |  6 ++----
 drivers/md/dm-bufio.c                       | 10 ++--------
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 15 ++++-----------
 fs/afs/fs_probe.c                           |  1 +
 fs/afs/server.c                             |  1 +
 fs/afs/vl_probe.c                           |  1 +
 fs/afs/volume.c                             |  1 +
 fs/aio.c                                    |  4 +---
 fs/block_dev.c                              |  1 +
 fs/btrfs/extent_io.c                        |  4 +---
 fs/cachefiles/namei.c                       |  1 +
 fs/cifs/connect.c                           |  3 +--
 fs/cifs/misc.c                              | 15 +++++----------
 fs/fscache/cookie.c                         |  2 ++
 fs/fscache/object.c                         |  2 ++
 fs/fscache/page.c                           |  3 +++
 fs/gfs2/glock.c                             |  8 ++------
 fs/gfs2/glops.c                             |  1 +
 fs/gfs2/lock_dlm.c                          |  8 ++------
 fs/gfs2/recovery.c                          |  4 +---
 fs/gfs2/super.c                             |  1 +
 fs/gfs2/sys.c                               |  4 +---
 fs/nfs/nfs4state.c                          |  4 +---
 fs/nfs/pnfs_nfs.c                           |  4 +---
 fs/nfsd/nfs4recover.c                       |  4 +---
 fs/orangefs/file.c                          |  2 +-
 kernel/sched/wait_bit.c                     |  1 +
 net/bluetooth/hci_event.c                   |  5 +----
 net/rds/ib_recv.c                           |  1 +
 security/keys/gc.c                          |  5 ++---
 33 files changed, 50 insertions(+), 90 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 813338288453..27523cfeac9a 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -356,11 +356,8 @@ static int btmtksdio_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 
 	if (hdr->evt == HCI_EV_VENDOR) {
 		if (test_and_clear_bit(BTMTKSDIO_TX_WAIT_VND_EVT,
-				       &bdev->tx_state)) {
-			/* Barrier to sync with other CPUs */
-			smp_mb__after_atomic();
+				       &bdev->tx_state))
 			wake_up_bit(&bdev->tx_state, BTMTKSDIO_TX_WAIT_VND_EVT);
-		}
 	}
 
 	return 0;
diff --git a/drivers/bluetooth/btmtkuart.c b/drivers/bluetooth/btmtkuart.c
index f5dbeec8e274..7fe324df3799 100644
--- a/drivers/bluetooth/btmtkuart.c
+++ b/drivers/bluetooth/btmtkuart.c
@@ -340,11 +340,8 @@ static int btmtkuart_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 
 	if (hdr->evt == HCI_EV_VENDOR) {
 		if (test_and_clear_bit(BTMTKUART_TX_WAIT_VND_EVT,
-				       &bdev->tx_state)) {
-			/* Barrier to sync with other CPUs */
-			smp_mb__after_atomic();
+				       &bdev->tx_state))
 			wake_up_bit(&bdev->tx_state, BTMTKUART_TX_WAIT_VND_EVT);
-		}
 	}
 
 	return 0;
diff --git a/drivers/bluetooth/hci_mrvl.c b/drivers/bluetooth/hci_mrvl.c
index 50212ac629e3..f03294d39d08 100644
--- a/drivers/bluetooth/hci_mrvl.c
+++ b/drivers/bluetooth/hci_mrvl.c
@@ -157,9 +157,7 @@ static int mrvl_recv_fw_req(struct hci_dev *hdev, struct sk_buff *skb)
 
 	mrvl->tx_len = le16_to_cpu(pkt->lhs);
 
-	clear_bit(STATE_FW_REQ_PENDING, &mrvl->flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&mrvl->flags, STATE_FW_REQ_PENDING);
+	clear_and_wake_up_bit(STATE_FW_REQ_PENDING, &mrvl->flags);
 
 done:
 	kfree_skb(skb);
@@ -192,9 +190,7 @@ static int mrvl_recv_chip_ver(struct hci_dev *hdev, struct sk_buff *skb)
 
 	bt_dev_info(hdev, "Controller id = %x, rev = %x", mrvl->id, mrvl->rev);
 
-	clear_bit(STATE_CHIP_VER_PENDING, &mrvl->flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&mrvl->flags, STATE_CHIP_VER_PENDING);
+	clear_and_wake_up_bit(STATE_CHIP_VER_PENDING, &mrvl->flags);
 
 done:
 	kfree_skb(skb);
diff --git a/drivers/gpu/drm/i915/i915_reset.c b/drivers/gpu/drm/i915/i915_reset.c
index 677d59304e78..6809367dbfa9 100644
--- a/drivers/gpu/drm/i915/i915_reset.c
+++ b/drivers/gpu/drm/i915/i915_reset.c
@@ -1324,10 +1324,8 @@ void i915_handle_error(struct drm_i915_private *i915,
 			if (i915_reset_engine(engine, msg) == 0)
 				engine_mask &= ~engine->mask;
 
-			clear_bit(I915_RESET_ENGINE + engine->id,
-				  &error->flags);
-			wake_up_bit(&error->flags,
-				    I915_RESET_ENGINE + engine->id);
+			clear_and_wake_up_bit(I915_RESET_ENGINE + engine->id,
+					      &error->flags);
 		}
 	}
 
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 2a48ea3f1b30..3114836cc717 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -667,10 +667,7 @@ static void write_endio(struct dm_buffer *b, blk_status_t status)
 	BUG_ON(!test_bit(B_WRITING, &b->state));
 
 	smp_mb__before_atomic();
-	clear_bit(B_WRITING, &b->state);
-	smp_mb__after_atomic();
-
-	wake_up_bit(&b->state, B_WRITING);
+	clear_and_wake_up_bit(B_WRITING, &b->state);
 }
 
 /*
@@ -1045,10 +1042,7 @@ static void read_endio(struct dm_buffer *b, blk_status_t status)
 	BUG_ON(!test_bit(B_READING, &b->state));
 
 	smp_mb__before_atomic();
-	clear_bit(B_READING, &b->state);
-	smp_mb__after_atomic();
-
-	wake_up_bit(&b->state, B_READING);
+	clear_and_wake_up_bit(B_READING, &b->state);
 }
 
 /*
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index e5e056bf9dfa..fa46bc930704 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -374,9 +374,7 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	usb_urb_killv2(&adap->stream);
 
 	/* clear 'streaming' status bit */
-	clear_bit(ADAP_STREAMING, &adap->state_bits);
-	smp_mb__after_atomic();
-	wake_up_bit(&adap->state_bits, ADAP_STREAMING);
+	clear_and_wake_up_bit(ADAP_STREAMING, &adap->state_bits);
 skip_feed_stop:
 
 	if (ret)
@@ -578,11 +576,8 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
 			goto err;
 	}
 err:
-	if (!adap->suspend_resume_active) {
-		clear_bit(ADAP_INIT, &adap->state_bits);
-		smp_mb__after_atomic();
-		wake_up_bit(&adap->state_bits, ADAP_INIT);
-	}
+	if (!adap->suspend_resume_active)
+		clear_and_wake_up_bit(ADAP_INIT, &adap->state_bits);
 
 	dev_dbg(&d->udev->dev, "%s: ret=%d\n", __func__, ret);
 	return ret;
@@ -619,9 +614,7 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 err:
 	if (!adap->suspend_resume_active) {
 		adap->active_fe = -1;
-		clear_bit(ADAP_SLEEP, &adap->state_bits);
-		smp_mb__after_atomic();
-		wake_up_bit(&adap->state_bits, ADAP_SLEEP);
+		clear_and_wake_up_bit(ADAP_SLEEP, &adap->state_bits);
 	}
 
 	dev_dbg(&d->udev->dev, "%s: ret=%d\n", __func__, ret);
diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index cfe62b154f68..377ee07d5f76 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -18,6 +18,7 @@ static bool afs_fs_probe_done(struct afs_server *server)
 
 	wake_up_var(&server->probe_outstanding);
 	clear_bit_unlock(AFS_SERVER_FL_PROBING, &server->flags);
+	smp_mb__after_atomic();
 	wake_up_bit(&server->flags, AFS_SERVER_FL_PROBING);
 	return true;
 }
diff --git a/fs/afs/server.c b/fs/afs/server.c
index e900cd74361b..c9b74a397cc1 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -569,6 +569,7 @@ bool afs_check_server_record(struct afs_fs_cursor *fc, struct afs_server *server
 	if (!test_and_set_bit_lock(AFS_SERVER_FL_UPDATING, &server->flags)) {
 		success = afs_update_server_record(fc, server);
 		clear_bit_unlock(AFS_SERVER_FL_UPDATING, &server->flags);
+		smp_mb__after_atomic();
 		wake_up_bit(&server->flags, AFS_SERVER_FL_UPDATING);
 		_leave(" = %d", success);
 		return success;
diff --git a/fs/afs/vl_probe.c b/fs/afs/vl_probe.c
index 858498cc1b05..1939624aa147 100644
--- a/fs/afs/vl_probe.c
+++ b/fs/afs/vl_probe.c
@@ -18,6 +18,7 @@ static bool afs_vl_probe_done(struct afs_vlserver *server)
 
 	wake_up_var(&server->probe_outstanding);
 	clear_bit_unlock(AFS_VLSERVER_FL_PROBING, &server->flags);
+	smp_mb__after_atomic();
 	wake_up_bit(&server->flags, AFS_VLSERVER_FL_PROBING);
 	return true;
 }
diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 08fdb3951c49..b968e4e96f6b 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -303,6 +303,7 @@ int afs_check_volume_status(struct afs_volume *volume, struct key *key)
 		ret = afs_update_volume_status(volume, key);
 		clear_bit_unlock(AFS_VOLUME_WAIT, &volume->flags);
 		clear_bit_unlock(AFS_VOLUME_UPDATING, &volume->flags);
+		smp_mb__after_atomic();
 		wake_up_bit(&volume->flags, AFS_VOLUME_WAIT);
 		_leave(" = %d", ret);
 		return ret;
diff --git a/fs/aio.c b/fs/aio.c
index 3490d1fa0e16..a21acb7ee2a5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1154,9 +1154,7 @@ static void aio_complete(struct aio_kiocb *iocb)
 	 * like in wake_up_bit() where clearing a bit has to be
 	 * ordered with the unlocked test.
 	 */
-	smp_mb();
-
-	if (waitqueue_active(&ctx->wait))
+	if (wq_has_sleeper(&ctx->wait))
 		wake_up(&ctx->wait);
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 749f5984425d..80e35cbfc7cc 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1687,6 +1687,7 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 		/* tell others that we're done */
 		BUG_ON(whole->bd_claiming != holder);
 		whole->bd_claiming = NULL;
+		smp_mb();
 		wake_up_bit(&whole->bd_claiming, 0);
 
 		spin_unlock(&bdev_lock);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index db337e53aab3..ee1136ae46fd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3683,9 +3683,7 @@ static noinline_for_stack int lock_extent_buffer_for_io(struct extent_buffer *eb
 
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
 {
-	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
-	smp_mb__after_atomic();
-	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
+	clear_and_wake_up_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
 }
 
 static void set_btree_ioerr(struct page *page)
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index ecc8ecbbfa5a..ecebba72ec7d 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -267,6 +267,7 @@ void cachefiles_mark_object_inactive(struct cachefiles_cache *cache,
 	clear_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags);
 	write_unlock(&cache->active_lock);
 
+	smp_mb__after_atomic();
 	wake_up_bit(&object->flags, CACHEFILES_OBJECT_ACTIVE);
 
 	/* This object can now be culled, so we need to let the daemon know
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8c4121da624e..8c1115ed1c28 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5235,8 +5235,7 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 	}
 
 	tlink->tl_tcon = cifs_construct_tcon(cifs_sb, fsuid);
-	clear_bit(TCON_LINK_PENDING, &tlink->tl_flags);
-	wake_up_bit(&tlink->tl_flags, TCON_LINK_PENDING);
+	clear_and_wake_up_bit(TCON_LINK_PENDING, &tlink->tl_flags);
 
 	if (IS_ERR(tlink->tl_tcon)) {
 		cifs_put_tlink(tlink);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index b1a696a73f7c..961751d89113 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -584,10 +584,8 @@ int cifs_get_writer(struct cifsInodeInfo *cinode)
 	/* Check to see if we have started servicing an oplock break */
 	if (test_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags)) {
 		cinode->writers--;
-		if (cinode->writers == 0) {
-			clear_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
-			wake_up_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS);
-		}
+		if (cinode->writers == 0)
+			clear_and_wake_up_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
 		spin_unlock(&cinode->writers_lock);
 		goto start;
 	}
@@ -599,10 +597,8 @@ void cifs_put_writer(struct cifsInodeInfo *cinode)
 {
 	spin_lock(&cinode->writers_lock);
 	cinode->writers--;
-	if (cinode->writers == 0) {
-		clear_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
-		wake_up_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS);
-	}
+	if (cinode->writers == 0)
+		clear_and_wake_up_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
 	spin_unlock(&cinode->writers_lock);
 }
 
@@ -630,8 +626,7 @@ void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
 
 void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
 {
-	clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
-	wake_up_bit(&cinode->flags, CIFS_INODE_PENDING_OPLOCK_BREAK);
+	clear_and_wake_up_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
 }
 
 bool
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 0ce39658a620..40ba8957ebf0 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -381,6 +381,7 @@ void __fscache_enable_cookie(struct fscache_cookie *cookie,
 
 out_unlock:
 	clear_bit_unlock(FSCACHE_COOKIE_ENABLEMENT_LOCK, &cookie->flags);
+	smp_mb__after_atomic();
 	wake_up_bit(&cookie->flags, FSCACHE_COOKIE_ENABLEMENT_LOCK);
 }
 EXPORT_SYMBOL(__fscache_enable_cookie);
@@ -778,6 +779,7 @@ void __fscache_disable_cookie(struct fscache_cookie *cookie,
 
 out_unlock_enable:
 	clear_bit_unlock(FSCACHE_COOKIE_ENABLEMENT_LOCK, &cookie->flags);
+	smp_mb__after_atomic();
 	wake_up_bit(&cookie->flags, FSCACHE_COOKIE_ENABLEMENT_LOCK);
 	_leave("");
 }
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index cfeba839a0f2..08b2edec6596 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -524,6 +524,7 @@ void fscache_object_lookup_negative(struct fscache_object *object)
 
 		_debug("wake up lookup %p", &cookie->flags);
 		clear_bit_unlock(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags);
+		smp_mb__after_atomic();
 		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP);
 	}
 	_leave("");
@@ -559,6 +560,7 @@ void fscache_obtained_object(struct fscache_object *object)
 		 * to begin shovelling data.
 		 */
 		clear_bit_unlock(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags);
+		smp_mb__after_atomic();
 		wake_up_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP);
 	} else {
 		fscache_stat(&fscache_n_object_created);
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 26af6fdf1538..49ef238502a3 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -113,6 +113,7 @@ bool __fscache_maybe_release_page(struct fscache_cookie *cookie,
 		fscache_stat(&fscache_n_store_vmscan_gone);
 	}
 
+	smp_mb();
 	wake_up_bit(&cookie->flags, 0);
 	trace_fscache_wake_cookie(cookie);
 	if (xpage)
@@ -171,6 +172,7 @@ static void fscache_end_page_write(struct fscache_object *object,
 			trace_fscache_page(cookie, page, fscache_page_write_end_pend);
 		}
 		spin_unlock(&cookie->stores_lock);
+		smp_mb();
 		wake_up_bit(&cookie->flags, 0);
 		trace_fscache_wake_cookie(cookie);
 	} else {
@@ -922,6 +924,7 @@ void fscache_invalidate_writes(struct fscache_cookie *cookie)
 			put_page(results[i]);
 	}
 
+	smp_mb();
 	wake_up_bit(&cookie->flags, 0);
 	trace_fscache_wake_cookie(cookie);
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f1ebcb42cbf5..8024b6bdb6d4 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -302,9 +302,7 @@ static inline int may_grant(const struct gfs2_glock *gl, const struct gfs2_holde
 
 static void gfs2_holder_wake(struct gfs2_holder *gh)
 {
-	clear_bit(HIF_WAIT, &gh->gh_iflags);
-	smp_mb__after_atomic();
-	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
+	clear_and_wake_up_bit(HIF_WAIT, &gh->gh_iflags);
 }
 
 /**
@@ -436,9 +434,7 @@ static void state_change(struct gfs2_glock *gl, unsigned int new_state)
 static void gfs2_demote_wake(struct gfs2_glock *gl)
 {
 	gl->gl_demote_state = LM_ST_EXCLUSIVE;
-	clear_bit(GLF_DEMOTE, &gl->gl_flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&gl->gl_flags, GLF_DEMOTE);
+	clear_and_wake_up_bit(GLF_DEMOTE, &gl->gl_flags);
 }
 
 /**
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index cf4c767005b1..666629ea5da7 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -227,6 +227,7 @@ static void gfs2_clear_glop_pending(struct gfs2_inode *ip)
 		return;
 
 	clear_bit_unlock(GIF_GLOP_PENDING, &ip->i_flags);
+	smp_mb__after_atomic();
 	wake_up_bit(&ip->i_flags, GIF_GLOP_PENDING);
 }
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 4361804646d8..0fa1865dd600 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -1139,9 +1139,7 @@ static void gdlm_recover_done(void *arg, struct dlm_slot *slots, int num_slots,
 	if (!test_bit(DFL_UNMOUNT, &ls->ls_recover_flags))
 		queue_delayed_work(gfs2_control_wq, &sdp->sd_control_work, 0);
 
-	clear_bit(DFL_DLM_RECOVERY, &ls->ls_recover_flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&ls->ls_recover_flags, DFL_DLM_RECOVERY);
+	clear_and_wake_up_bit(DFL_DLM_RECOVERY, &ls->ls_recover_flags);
 	spin_unlock(&ls->ls_recover_spin);
 }
 
@@ -1276,9 +1274,7 @@ static int gdlm_mount(struct gfs2_sbd *sdp, const char *table)
 	}
 
 	ls->ls_first = !!test_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags);
-	clear_bit(SDF_NOJOURNALID, &sdp->sd_flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&sdp->sd_flags, SDF_NOJOURNALID);
+	clear_and_wake_up_bit(SDF_NOJOURNALID, &sdp->sd_flags);
 	return 0;
 
 fail_release:
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 2299a3fa1911..ef9a8ef6689b 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -436,9 +436,7 @@ void gfs2_recover_func(struct work_struct *work)
 	jd->jd_recover_error = error;
 	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_GAVEUP);
 done:
-	clear_bit(JDF_RECOVERY, &jd->jd_flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
+	clear_and_wake_up_bit(JDF_RECOVERY, &jd->jd_flags);
 }
 
 int gfs2_recover_journal(struct gfs2_jdesc *jd, bool wait)
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b70cea5c8c59..28ff2e10bdd9 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -985,6 +985,7 @@ void gfs2_freeze_func(struct work_struct *work)
 	}
 	deactivate_super(sb);
 	clear_bit_unlock(SDF_FS_FROZEN, &sdp->sd_flags);
+	smp_mb__after_atomic();
 	wake_up_bit(&sdp->sd_flags, SDF_FS_FROZEN);
 	return;
 }
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 159aedf63c2a..b337798d8957 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -505,9 +505,7 @@ static ssize_t jid_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	if (sdp->sd_args.ar_spectator && jid > 0)
 		rv = jid = -EINVAL;
 	sdp->sd_lockstruct.ls_jid = jid;
-	clear_bit(SDF_NOJOURNALID, &sdp->sd_flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&sdp->sd_flags, SDF_NOJOURNALID);
+	clear_and_wake_up_bit(SDF_NOJOURNALID, &sdp->sd_flags);
 out:
 	spin_unlock(&sdp->sd_jindex_spin);
 	return rv ? rv : len;
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index e2e3c4f04d3e..a3ed413a38c5 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1196,9 +1196,7 @@ static int nfs4_run_state_manager(void *);
 static void nfs4_clear_state_manager_bit(struct nfs_client *clp)
 {
 	smp_mb__before_atomic();
-	clear_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state);
-	smp_mb__after_atomic();
-	wake_up_bit(&clp->cl_state, NFS4CLNT_MANAGER_RUNNING);
+	clear_and_wake_up_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state);
 	rpc_wake_up(&clp->cl_rpcwaitq);
 }
 
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index c0046c348910..37c4fe5a595c 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -567,9 +567,7 @@ static void nfs4_wait_ds_connect(struct nfs4_pnfs_ds *ds)
 static void nfs4_clear_ds_conn_bit(struct nfs4_pnfs_ds *ds)
 {
 	smp_mb__before_atomic();
-	clear_bit(NFS4DS_CONNECTING, &ds->ds_state);
-	smp_mb__after_atomic();
-	wake_up_bit(&ds->ds_state, NFS4DS_CONNECTING);
+	clear_and_wake_up_bit(NFS4DS_CONNECTING, &ds->ds_state);
 }
 
 static struct nfs_client *(*get_v3_ds_connect)(
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 87679557d0d6..0a30f9cdf66a 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -1638,9 +1638,7 @@ static void
 nfsd4_cltrack_upcall_unlock(struct nfs4_client *clp)
 {
 	smp_mb__before_atomic();
-	clear_bit(NFSD4_CLIENT_UPCALL_LOCK, &clp->cl_flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&clp->cl_flags, NFSD4_CLIENT_UPCALL_LOCK);
+	clear_and_wake_up_bit(NFSD4_CLIENT_UPCALL_LOCK, &clp->cl_flags);
 }
 
 static void
diff --git a/fs/orangefs/file.c b/fs/orangefs/file.c
index a35c17017210..1958bb457143 100644
--- a/fs/orangefs/file.c
+++ b/fs/orangefs/file.c
@@ -302,7 +302,7 @@ int orangefs_revalidate_mapping(struct inode *inode)
 	orangefs_inode->mapping_time = jiffies +
 	    orangefs_cache_timeout_msecs*HZ/1000;
 
-	clear_bit(1, bitlock);
+	clear_bit_unlock(1, bitlock);
 	smp_mb__after_atomic();
 	wake_up_bit(bitlock, 1);
 
diff --git a/kernel/sched/wait_bit.c b/kernel/sched/wait_bit.c
index 45eba18a2898..2662975473e3 100644
--- a/kernel/sched/wait_bit.c
+++ b/kernel/sched/wait_bit.c
@@ -189,6 +189,7 @@ EXPORT_SYMBOL(init_wait_var_entry);
 
 void wake_up_var(void *var)
 {
+	smp_mb();
 	__wake_up_bit(__var_waitqueue(var), var, -1);
 }
 EXPORT_SYMBOL(wake_up_var);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9e4fcf406d9c..4e57f1a1b7a2 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -50,9 +50,7 @@ static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb)
 	if (status)
 		return;
 
-	clear_bit(HCI_INQUIRY, &hdev->flags);
-	smp_mb__after_atomic(); /* wake_up_bit advises about this barrier */
-	wake_up_bit(&hdev->flags, HCI_INQUIRY);
+	clear_and_wake_up_bit(HCI_INQUIRY, &hdev->flags);
 
 	hci_dev_lock(hdev);
 	/* Set discovery state to stopped if we're not doing LE active
@@ -2342,7 +2340,6 @@ static void hci_inquiry_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	if (!test_and_clear_bit(HCI_INQUIRY, &hdev->flags))
 		return;
 
-	smp_mb__after_atomic(); /* wake_up_bit advises about this barrier */
 	wake_up_bit(&hdev->flags, HCI_INQUIRY);
 
 	if (!hci_dev_test_flag(hdev, HCI_MGMT))
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 3cae88cbdaa0..2c2773172964 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -363,6 +363,7 @@ static int acquire_refill(struct rds_connection *conn)
 static void release_refill(struct rds_connection *conn)
 {
 	clear_bit(RDS_RECV_REFILL, &conn->c_flags);
+	smp_mb__after_atomic();
 
 	/* We don't use wait_on_bit()/wake_up_bit() because our waking is in a
 	 * hot path and finding waiters is very rare.  We don't want to walk
diff --git a/security/keys/gc.c b/security/keys/gc.c
index 44e58a3e5663..f452816bd7d0 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -308,9 +308,8 @@ static void key_garbage_collector(struct work_struct *work)
 
 	if (unlikely(gc_state & KEY_GC_REAPING_DEAD_3)) {
 		kdebug("dead wake");
-		smp_mb();
-		clear_bit(KEY_GC_REAPING_KEYTYPE, &key_gc_flags);
-		wake_up_bit(&key_gc_flags, KEY_GC_REAPING_KEYTYPE);
+		smp_mb__before_atomic();
+		clear_and_wake_up_bit(KEY_GC_REAPING_KEYTYPE, &key_gc_flags);
 	}
 
 	if (gc_state & KEY_GC_REAP_AGAIN)
