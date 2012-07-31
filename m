From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] zero-copy extensions for rsockets
Date: Tue, 31 Jul 2012 18:18:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A6E8D5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Christoph Lameter (christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org)" <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, "Greg KH (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Before implementing this, I'm looking for feedback.  The following proposal defines user-space APIs to support zero-copy.  The intent is that the use of these extensions is fully compatible with existing calls, allowing applications to make selective use of them.  Although I'm specifically looking at these calls for rsockets, I tried to make these generic enough that they could apply to a wider variety of technologies.

- Sean

--

/* Define option/flag to indicate asynchronous operation */
#define O_ASYNC ...	/* fcntl option */
#define MSG_ASYNC ...	/* send/recv flag */

/*
 * ioq - fd used to report asynchronous completions.
 * sockets/fd's report asynchronous events through an associated ioq
 * ioq is usable with standard calls - fcntl, select, poll, read, etc.
 */
int ioq_create(int flags);
int ioq_add(int ioq, int fd, int flags);
int ioq_del(int ioq, int fd);

/* Reading from an ioq returns this structure */
struct ioq_event {
	int fd;
	int operation;	/* IOREAD, IOWRITE, etc. */
	int result;		/* e.g. bytes transferred */
	int errno;
	void *ptr;		/* context, e.g. address */
};

/* Register memory for zero-copy. */
off_t iomap(int fd, void *addr, size_t len, int prot, int flags, off_t offset);
int iounmap(int fd, off_t offset, size_t len);

/*
 * Zero-copy read and write calls.
 * If fd is nonblocking, then the operation must as asynchronous.
 */
size_t get(int fd, void *buf, size_t count, off_t offset, int flags);
size_t put(int fd, const void *buf, size_t count, off_t offset, int flags);

/* Technology specific operation */
int submit(int fd,
           int operation,	/* IOREAD, IOWRITE, vendor defined, etc. */
           void *context,
           void *request,	/* request structures varies by operation */
           size_t len,		/* size of request structure */
           int flags);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
