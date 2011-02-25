From: "Bharath Ramesh" <bramesh-PjAqaU27lzQ@public.gmane.org>
Subject: RE: IB atomic operations
Date: Fri, 25 Feb 2011 13:30:31 -0500
Message-ID: <014f01cbd51a$15c180a0$414481e0$@edu>
References: <00b701cbd4bd$e271fe20$a755fa60$@edu> <4D67D17C.7000405@systemfabricworks.com> <00e401cbd505$a437bc60$eca73520$@edu> <4D67D4F2.4040404@systemfabricworks.com> <00f401cbd509$96834b80$c389e280$@edu> <4D67E006.8000705@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="----=_NextPart_000_0149_01CBD4F0.2CAA50F0";
	protocol="application/x-pkcs7-signature";
	micalg=SHA1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D67E006.8000705-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0149_01CBD4F0.2CAA50F0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_001_014A_01CBD4F0.2CAA50F0"


------=_NextPart_001_014A_01CBD4F0.2CAA50F0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

> -----Original Message-----
> From: frank zago [mailto:fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org]
> 
> Sorry, I don't see what's wrong.

Could there be a reason why it would fail on certain nodes but run on other
nodes. I picked two other nodes and ran the attached test code. It runs fine
there without any issues, the hardware is same across all nodes of the
cluster.

Regards,

Bharath

------=_NextPart_001_014A_01CBD4F0.2CAA50F0
Content-Type: application/octet-stream;
	name="fetch_add.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fetch_add.c"

#include <getopt.h>
#include <infiniband/verbs.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define IB_MAX_CQE 1024
#define IB_MAX_RD_ATOMIC 8
#define IB_MAX_WR 1024
#define IB_MAX_SGE 8
#define IB_PORT 1
#define IB_RETRY_CNT 7
#define IB_RNR_RETRY 7
#define IB_RNR_TIMER 12
#define IB_TIMEOUT 14
#define TCP_MSG_SIZE 48

void client (char *);
void server (void);
static int connect_ibverbs_qp (struct ibv_qp *, int, int);
static struct ibv_qp *create_ibverbs_qp (void);
static void query_ibverbs_qp (struct ibv_qp *);
static void ibverbs_exit (void);
static int ibverbs_init (void);
static void usage (const char *);

static int count = 100;
static uint64_t data = 0;
static struct ibv_cq *ib_cq = NULL;
static struct ibv_context *ib_ctx = NULL;
static uint16_t ib_lid = 0;
static struct ibv_mr *ib_mr = NULL;
static enum ibv_mtu ib_mtu = 0;
static struct ibv_pd *ib_pd = NULL;
static struct ibv_qp *ib_qp = NULL;

int
main (int argc, char *argv[])
{
	int c = 0;
	struct option opts[] = {
		{.name = "count", .has_arg = 1, .val = 'c'},
		{.name = "help", .has_arg = 0, .val = 'h'},
		{.name = NULL, .has_arg = 0, .val = 0}
	};
	char *host = NULL;

	while (c != EOF) {
		c = getopt_long (argc, argv, "c:h", opts, NULL);
		switch (c) {
			case EOF:
				break;

			case 'c':
				count = atoi (optarg);
				break;

			case '?':
			case 'h':
			default:
				usage (argv[0]);
		}
	}

	if (optind == (argc - 1)) {
		host = strdup (argv[optind]);
	} else if (optind < argc) {
		usage (argv[0]);
	}

	if (ibverbs_init () != 0) {
		printf ("ERROR: ibverbs_init failed.\n");
		return EXIT_FAILURE;
	}

	if (host == NULL)
		server ();
	else
		client (host);

	ibverbs_exit ();
	if (host != NULL)
		free (host);

	return EXIT_SUCCESS;
}

void
client (char *host)
{
	struct hostent *he;
	int lid, qpn, sock;
	char msg[TCP_MSG_SIZE];
	struct sockaddr_in sock_addr;

	ib_qp = create_ibverbs_qp ();
	if (ib_qp == NULL) {
		printf ("ERROR: create_ibverbs_qp failed.\n");
		return;
	}

	if ((sock = socket (PF_INET, SOCK_STREAM, 0)) == -1) {
		printf ("ERROR: socket failed.\n");
		return;
	}

	if ((he = gethostbyname (host)) == NULL) {
		printf ("ERROR: gethostbyname failed.\n");
		close (sock);
		return;
	}

	memset (&sock_addr, 0, sizeof (struct sockaddr_in));
	sock_addr.sin_family = AF_INET;
	sock_addr.sin_addr = *((struct in_addr *) he->h_addr);
	sock_addr.sin_port = htons (23380);
	if (connect (sock, (struct sockaddr *) &sock_addr,
				sizeof (struct sockaddr_in)) == -1) {
		printf ("ERROR: connect failed.\n");
		close (sock);
		return;
	}

	memset (msg, 0, sizeof (char) * TCP_MSG_SIZE);
	sprintf (msg, "%08x:%08x:%08x:%016lx", ib_lid, ib_qp->qp_num,
			ib_mr->rkey, (uint64_t) &data);
	if (write (sock, msg, sizeof (char) * TCP_MSG_SIZE)
			!=  sizeof (char) * TCP_MSG_SIZE) {
		printf ("ERROR: write failed.\n");
		close (sock);
		return;
	}

	if (read (sock, msg, sizeof (char) * TCP_MSG_SIZE)
			!=  sizeof (char) * TCP_MSG_SIZE) {
		printf ("ERROR: read failed.\n");
		close (sock);
		return;
	}

	sscanf (msg, "%x:%x", &lid, &qpn);
	if (connect_ibverbs_qp (ib_qp, lid, qpn) != 0) {
		printf ("ERROR: connect_ibverbs_qp failed.\n");
		close (sock);
		return;
	}

	if (write (sock, msg, sizeof (char) * TCP_MSG_SIZE)
			!=  sizeof (char) * TCP_MSG_SIZE) {
		printf ("ERROR: write failed.\n");
		close (sock);
		return;
	}

	if (read (sock, msg, sizeof (char) * TCP_MSG_SIZE)
			!=  sizeof (char) * TCP_MSG_SIZE) {
		printf ("ERROR: read failed.\n");
		close (sock);
		return;
	}

	printf ("data: %lu\n", data);
	if (sock != -1)
		close (sock);

	return;
}

void
server (void)
{
	int c, cli, i, j, k, lid, qpn, ret, sock;
	char msg[TCP_MSG_SIZE];
	uint32_t rkey;
	struct ibv_sge sge;
	struct sockaddr_in sock_addr;
	uint64_t vaddr;
	int val = 1;
	struct ibv_wc wc;
	struct ibv_send_wr wr, *wr_bad;

	ib_qp = create_ibverbs_qp ();
	if (ib_qp == NULL) {
		printf ("ERROR: create_ibverbs_qp failed.\n");
		return;
	}

	if ((sock = socket (PF_INET, SOCK_STREAM, 0)) == -1) {
		printf ("ERROR: socket failed.\n");
		return;
	}

	if (setsockopt (sock, SOL_SOCKET, SO_REUSEADDR, &val, sizeof (int))
			== -1) {
		printf ("ERROR: setsockopt failed.\n");
		close (sock);
		return;
	}

	memset (&sock_addr, 0, sizeof (struct sockaddr_in));
	sock_addr.sin_family = AF_INET;
	sock_addr.sin_addr.s_addr = htonl (INADDR_ANY);
	sock_addr.sin_port = htons (23380);
	if (bind (sock, (struct sockaddr *) &sock_addr,
				sizeof (struct sockaddr_in)) == -1) {
		printf ("ERROR: bind failed.\n");
		close (sock);
		return;
	}

	if (listen (sock, 2) == -1) {
		printf ("ERROR: listen failed.\n");
		close (sock);
		return;
	}

	if ((cli = accept (sock, NULL, NULL)) == -1) {
		printf ("ERROR: accept failed.\n");
		close (sock);
		return;
	}

	if (read (cli, msg, sizeof (char) * TCP_MSG_SIZE)
			!=  sizeof (char) * TCP_MSG_SIZE) {
		printf ("ERROR: read failed.\n");
		close (cli);
		close (sock);
		return;
	}

	sscanf (msg, "%x:%x:%x:%lx", &lid, &qpn, &rkey, &vaddr);
	memset (msg, 0, sizeof (char) * TCP_MSG_SIZE);
	sprintf (msg, "%08x:%08x", ib_lid, ib_qp->qp_num);
	if (write (cli, msg, sizeof (char) * TCP_MSG_SIZE)
			!= sizeof (char) * TCP_MSG_SIZE) {
		printf ("ERROR: write failed.\n");
		close (cli);
		close (sock);
		return;
	}

	if (connect_ibverbs_qp (ib_qp, lid, qpn) != 0) {
		printf ("ERROR: connect_ibverbs_qp failed.\n");
		close (sock);
		return;
	}

	if (read (cli, msg, sizeof (char) * TCP_MSG_SIZE)
			!=  sizeof (char) * TCP_MSG_SIZE) {
		printf ("ERROR: read failed.\n");
		close (cli);
		close (sock);
		return;
	}

	sge.addr = (uintptr_t) &data;
	sge.length = sizeof (uint64_t);
	sge.lkey = ib_mr->lkey;
	wr.opcode = IBV_WR_ATOMIC_FETCH_AND_ADD;
	wr.send_flags = IBV_SEND_SIGNALED;
	wr.next = NULL;
	wr.num_sge = 1;
	wr.sg_list = &sge;
	wr.wr.atomic.remote_addr = vaddr;
	wr.wr.atomic.compare_add = 1;
	//wr.wr.atomic.swap = 0;
	wr.wr.atomic.rkey = rkey;
	for (i = 0, j = 0; i < count; i++) {
		wr.wr_id = (uint64_t) i + 1;
		ret = ibv_post_send (ib_qp, &wr, &wr_bad);
		if (ret != 0) {
			printf ("ERROR: ibv_post_send failed.\n");
			printf ("i: %d\n", i);
			return;
		}

		++j;
		if ((i % IB_MAX_RD_ATOMIC) == 0) {
			for (k = 0; k < j; k++) {
				do {
					c = ibv_poll_cq (ib_cq, 1, &wc);
				} while (c == 0);

				if (c < 0) {
					printf ("ERROR: ibv_poll_cq failed.\n");
					return;
				}

				if (wc.status != IBV_WC_SUCCESS) {
					printf ("ERROR: work request completion"
							" failed.\n");
					printf ("wc status: %d, wrid: %lu, "
							"vendor err: %d\n",
							wc.status, wc.wr_id,
							wc.vendor_err);
					printf ("i: %d, j: %d\n", i, j);
					query_ibverbs_qp (ib_qp);
					return;
				}
			}

			printf ("j: %d\n", j);
			j = 0;
		}
	}

	if (j != 0) {
		for (k = 0; k < j; k++) {
			do {
				c = ibv_poll_cq (ib_cq, 1, &wc);
			} while (c == 0);

			if (c < 0) {
				printf ("ERROR: ibv_poll_cq failed.\n");
				return;
			}

			if (wc.status != IBV_WC_SUCCESS) {
				printf ("ERROR: work request completion "
						"failed.\n");
				printf ("wc status: %d, wrid: %lu, vendor err: "
						"%d\n", wc.status, wc.wr_id,
						wc.vendor_err);
				printf ("i: %d, j: %d\n", i, j);
				query_ibverbs_qp (ib_qp);
				return;
			}
		}

		printf ("j: %d\n", j);
		j = 0;
	}

	if (write (cli, msg, sizeof (char) * TCP_MSG_SIZE)
			!= sizeof (char) * TCP_MSG_SIZE) {
		printf ("ERROR: write failed.\n");
		close (cli);
		close (sock);
		return;
	}

	printf ("data: %lu\n", data);
	if (cli != -1)
		close (cli);

	if (sock != -1)
		close (sock);

	return;
}

static int
connect_ibverbs_qp (struct ibv_qp *qp, int lid, int qpn)
{
       struct ibv_qp_attr attr;

        // Transition the QP to RTR.
        memset (&attr, 0, sizeof (struct ibv_qp_attr));
        attr.qp_state = IBV_QPS_RTR;
        attr.path_mtu = ib_mtu;
        attr.dest_qp_num = qpn;
        attr.rq_psn = 0;
        attr.max_dest_rd_atomic = IB_MAX_RD_ATOMIC;
        attr.min_rnr_timer = IB_RNR_TIMER;
        attr.ah_attr.is_global = 0;
        attr.ah_attr.dlid = lid;
        attr.ah_attr.sl = 0;
        attr.ah_attr.src_path_bits = 0;
        attr.ah_attr.port_num = IB_PORT;
        if (ibv_modify_qp (qp, &attr, IBV_QP_STATE | IBV_QP_AV |
                                IBV_QP_PATH_MTU | IBV_QP_DEST_QPN |
                                IBV_QP_RQ_PSN | IBV_QP_MAX_DEST_RD_ATOMIC |
                                IBV_QP_MIN_RNR_TIMER) != 0) {
                printf ("ERROR: Unable to modify QP to RTR state.\n");
                return -1;
        }

        // Transition the QP to RTS.
        attr.timeout = IB_TIMEOUT;
        attr.retry_cnt = IB_RETRY_CNT;
        attr.rnr_retry = IB_RNR_RETRY;
        attr.qp_state = IBV_QPS_RTS;
        attr.sq_psn = 0;
        attr.max_rd_atomic = IB_MAX_RD_ATOMIC;
        if (ibv_modify_qp (qp, &attr, IBV_QP_STATE | IBV_QP_SQ_PSN |
                                IBV_QP_MAX_QP_RD_ATOMIC | IBV_QP_RETRY_CNT |
                                IBV_QP_RNR_RETRY | IBV_QP_TIMEOUT) != 0) {
                printf ("ERROR: Unable to modify QP to RTS state.\n");
                return -1;
        }

        return 0;
}

static struct ibv_qp *
create_ibverbs_qp (void)
{
	struct ibv_qp_attr attr;
        struct ibv_qp_init_attr init_attr;
        struct ibv_qp *qp;

        memset (&init_attr, 0, sizeof (struct ibv_qp_init_attr));
        init_attr.recv_cq = ib_cq;
        init_attr.send_cq = ib_cq;
        init_attr.cap.max_recv_wr = IB_MAX_WR;
        init_attr.cap.max_send_wr = IB_MAX_WR;
        init_attr.cap.max_recv_sge = IB_MAX_SGE;
        init_attr.cap.max_send_sge = IB_MAX_SGE;
        init_attr.qp_type = IBV_QPT_RC;
        qp = ibv_create_qp (ib_pd, &init_attr);
        if (qp == NULL) {
                printf ("ERROR: Unable to create IB verbs QP.\n");
                return NULL;
        }

        // Transition QP to INIT state.
        attr.qp_state = IBV_QPS_INIT;
        attr.pkey_index = 0;
        attr.port_num = IB_PORT;
        attr.qp_access_flags = IBV_ACCESS_LOCAL_WRITE
		| IBV_ACCESS_REMOTE_ATOMIC | IBV_ACCESS_REMOTE_READ
		| IBV_ACCESS_REMOTE_WRITE;
        if (ibv_modify_qp (qp, &attr, IBV_QP_STATE | IBV_QP_PKEY_INDEX |
                                IBV_QP_PORT | IBV_QP_ACCESS_FLAGS) != 0) {
                printf ("ERROR: Unable to modify QP to INIT state.\n");
                if (ibv_destroy_qp (qp) != 0)
                        printf ("ERROR: Unable to destroy IB verbs QP.\n");

                return NULL;
        }

        return qp;
}

static void
query_ibverbs_qp (struct ibv_qp *qp)
{
	struct ibv_qp_attr attr;
	struct ibv_qp_init_attr init_attr;
	enum ibv_qp_attr_mask mask;
	int ret;

	mask = IBV_QP_STATE | IBV_QP_MAX_QP_RD_ATOMIC |
		IBV_QP_MAX_DEST_RD_ATOMIC;
	ret = ibv_query_qp (qp, &attr, mask, &init_attr);
	if (ret != 0) {
		printf ("ERROR: Unable to query QP.\n");
		printf ("Info: retval: %d\n", ret);
		return;
	}

	printf ("Info: QP state: %d\n", attr.qp_state);
	printf ("Info: Max QP RD Atomic: %d\n", attr.max_rd_atomic);
	printf ("Info: Max QP Dest RD Atomic: %d\n", attr.max_dest_rd_atomic);

	return;
}

static void
ibverbs_exit (void)
{
	if (ib_qp != NULL)
		ibv_destroy_qp (ib_qp);
	
	if (ib_mr != NULL)
		ibv_dereg_mr (ib_mr);

	if (ib_cq != NULL)
		ibv_destroy_cq (ib_cq);

	if (ib_pd != NULL)
		ibv_dealloc_pd (ib_pd);

	if (ib_ctx != NULL)
		ibv_close_device (ib_ctx);

	return;
}

static int
ibverbs_init (void)
{
	struct ibv_device *ib_dev, **ib_dev_list;
	int ndevs;
	struct ibv_port_attr port_attr;

	ib_dev_list = ibv_get_device_list (&ndevs);
	if (ndevs == 0) {
		printf ("ERROR: No IB device(s) found.\n");
		return -1;
	}

	ib_dev = ib_dev_list[0];
	ib_ctx = ibv_open_device (ib_dev);
	if (ib_ctx == NULL) {
		printf ("ERROR: ibv_open_device failed.\n");
		return -1;
	}

	if (ibv_query_port (ib_ctx, IB_PORT, &port_attr) != 0) {
		printf ("ERROR: ibv_query_device failed.\n");
		return -1;
	}

	ib_lid = port_attr.lid;
	ib_mtu = port_attr.active_mtu;
	ib_pd = ibv_alloc_pd (ib_ctx);
	if (ib_pd == NULL) {
		printf ("ERROR: ibv_alloc_pd failed.\n");
		return -1;
	}

	ib_cq = ibv_create_cq (ib_ctx, IB_MAX_CQE, NULL, NULL, 0);
	if (ib_cq == NULL) {
		printf ("ERROR: ibv_create_cq failed.\n");
		return -1;
	}

	ib_mr = ibv_reg_mr (ib_pd, &data, sizeof (uint64_t),
			IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_REMOTE_ATOMIC
			| IBV_ACCESS_REMOTE_READ | IBV_ACCESS_REMOTE_WRITE);
	if (ib_mr == NULL) {
		printf ("ERROR: ibv_reg_mr failed.\n");
		return -1;
	}

	if (ib_dev_list != NULL)
		ibv_free_device_list (ib_dev_list);

	return 0;
}

static void
usage (const char *name)
{
	printf ("usage:\n");
	printf ("\t%s [options]\t\tstart a server and wait for connection.\n",
			name);
	printf ("\t%s [options] <host>\tconnect to server at <host>.\n",
			name);
	printf ("\noptions:\n");
	printf ("\t-c, --count=<count>\tatomic counts up to <count>(default: "
			"100).\n");
	printf ("\t-h, --help\t\tprint this message and quit.\n");
	exit (EXIT_SUCCESS);
}

------=_NextPart_001_014A_01CBD4F0.2CAA50F0--

------=_NextPart_000_0149_01CBD4F0.2CAA50F0
Content-Type: application/x-pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOhTCCBDIw
ggMaoAMCAQICAQEwDQYJKoZIhvcNAQEFBQAwezELMAkGA1UEBhMCR0IxGzAZBgNVBAgMEkdyZWF0
ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBwwHU2FsZm9yZDEaMBgGA1UECgwRQ29tb2RvIENBIExpbWl0
ZWQxITAfBgNVBAMMGEFBQSBDZXJ0aWZpY2F0ZSBTZXJ2aWNlczAeFw0wNDAxMDEwMDAwMDBaFw0y
ODEyMzEyMzU5NTlaMHsxCzAJBgNVBAYTAkdCMRswGQYDVQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIx
EDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9kbyBDQSBMaW1pdGVkMSEwHwYDVQQDDBhB
QUEgQ2VydGlmaWNhdGUgU2VydmljZXMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+
QJ30buHqdoccTUVEjr5GyIMGncEq/hgfjuQC+vOrXVCKFjELmgbQxXAizUktVGPMtm5oRgtT6stM
JMC8ck7q8RWu9FSaEgrDerIzYOLaiVXzIljz3tzP74OGooyUT59o8piQRoQnx3a/48w1LIteB2Rl
gsBIsKiR+WGfdiBQqJHHZrXreGIDVvCKGhPqMaMeoJn9OPb2JzJYbwf1a7j7FCuvt6rM1mNfc4za
BZmoOKjLF3g2UazpnvR4Oo3PD9lC4pgMqy+fDgHe75+ZSfEt36x0TRuYtUfF5SnR+ZAYx2KcvoPH
Jns+iiXHwN2d5jVoECCdj9je0sOEnA1e6C/JAgMBAAGjgcAwgb0wHQYDVR0OBBYEFKARCiM+lvEH
7OKvKe+CpX/QMKS0MA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MHsGA1UdHwR0MHIw
OKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmljYXRlU2VydmljZXMuY3Js
MDagNKAyhjBodHRwOi8vY3JsLmNvbW9kby5uZXQvQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmww
DQYJKoZIhvcNAQEFBQADggEBAAhW/ALwm+j/pPrWe8ZEgM5PxMX2AFjMpra8FEloBHbo5u5d7AIP
YNaNUBhPJk4B4+awpe6/vHRUQb/9/BK4x09a9IlgBX9gtwVK8/bxwr/EuXSGti19a8zS80bdL8bg
asPDNAMsfZbdWsIOpwqZwQWLqwwv81w6z2w3VQmH3lNAbFjv/LarZW4E9hvcPOBaFcae2fFZSDAh
ZQNs7Okhc+ybA6HgN62gFRiP+roCzqcsqRATLNTlCCarIpdg+JBedNSimlO98qlo4KJuwtdssaMP
nr/raOdW8q7y4ys4OgmBtWuF174t7T8at7Jj4vViLILUagBBUPE5g5+V6TaWmG4wggTdMIIDxaAD
AgECAhBxkvvmGV+sTRKFdHE0ohinMA0GCSqGSIb3DQEBBQUAMHsxCzAJBgNVBAYTAkdCMRswGQYD
VQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9k
byBDQSBMaW1pdGVkMSEwHwYDVQQDDBhBQUEgQ2VydGlmaWNhdGUgU2VydmljZXMwHhcNMDQwMTAx
MDAwMDAwWhcNMjgxMjMxMjM1OTU5WjCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYD
VQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYD
VQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xp
ZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALI5haTyfatBO2JGN67NwWB1vDll+UoaR6K5zEjMapjVTTUZuaRC5c5J4oovHnzSMQfHTrSD
ZJ0uKdWiZMSFvYVRNXmkTmiQexx6pJKoF/KYFfKTzMmkMpW7DE8wvZigC4vlbhuiRvp4vKJvq1le
pS/Pytptqi/rrKGzaqq3Lmc1i3nhHmmI4uZGzaCl6r4LznY6eg6b6vzaJ1s9cx8i5khhxkzzabGo
Lhu21DEgLLyCio6kDqXXiUP8FlqvHXHXEVnauocNr/rz4cLwpMVnjNbWVDreCqS6A3ezZcj9HtN0
YqoYymiTHqGFfvVHZcv4TVcodNI0/zC27vZiMBSMLOsCAwEAAaOCAScwggEjMB8GA1UdIwQYMBaA
FKARCiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBSJgmd9xJ0mcABLtFBIfN49rgRufTAOBgNV
HQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUH
AwQwEQYDVR0gBAowCDAGBgRVHSAAMHsGA1UdHwR0MHIwOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2Rv
Y2EuY29tL0FBQUNlcnRpZmljYXRlU2VydmljZXMuY3JsMDagNKAyhjBodHRwOi8vY3JsLmNvbW9k
by5uZXQvQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwEQYJYIZIAYb4QgEBBAQDAgEGMA0GCSqG
SIb3DQEBBQUAA4IBAQCdlcs8uH6lCcQevwvCx3aOOTyUxhCqTwzJ4KuEXYlU4GU7820cfDcsJVRf
liH8N4SRnRXcFE+Bz1Qda2xFYMct+ZdRTPlmyjyggoymyPDi6dRK+ew/VsnddozDggFPbADzHhph
dARHA6nGQFeRvGUixSdnT1fbZFrZjR+6hi/0Bq6cae3p9M8pF9jgSp8aIC+XTFG7RgfEijdOIOMJ
MWjHnsSLneh+EbwyaBCWEZhE2CpRYE2I63Q630MGMsg5Vow6EVLTQaRDA/Tt7zMn2zngFE4mydj1
OeKJuJNdtykmQeqzm66D/Hd1yujKtf7iZUpjPkTE0MNeh3OpmByvfxV/MIIFajCCBFKgAwIBAgIQ
YcOeSMr+SboU7E8CNVWuhDANBgkqhkiG9w0BAQUFADCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgT
AlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3
b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VS
Rmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDAeFw0xMDExMTcwMDAwMDBaFw0x
MTExMTcyMzU5NTlaMB8xHTAbBgkqhkiG9w0BCQEWDmJyYW1lc2hAdnQuZWR1MIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsK1UEXu6lbG6ggSIHF8f65XaOGcpxNiqSHp7EJk7v3FcJ9aY
2/jFUQcQPc2FwZMKvRdOGOEsnX71hxOTo+K3lPNa8D5Aijv4qck+bt/p7xZOPPvJrTTnA0Y+gJev
WeblYh8GV8OCassour7rHxXxlteeBq5mIQ4ha0zaozLlAIhXGBTPtNX2yu40cQ3my/kWqAxB6tjk
XFb3oR/UaROC/zivQeDj3pVvdSeUA1vDag9K0gr0svKEy1qvj9D0j7Yj9czjm7ZdZXbkYwplQBaw
4Wjx2o6g93MuNroozvly+0HNi1x3GJdGuOrI4pZMXTitDk4CNwQALp2iq3NwFIYUCQIDAQABo4IC
EDCCAgwwHwYDVR0jBBgwFoAUiYJnfcSdJnAAS7RQSHzePa4Ebn0wHQYDVR0OBBYEFHtZ/WL8KZ/o
2o7Q6DSPYyhCVQxbMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMCAGA1UdJQQZMBcGCCsG
AQUFBwMEBgsrBgEEAbIxAQMFAjARBglghkgBhvhCAQEEBAMCBSAwRgYDVR0gBD8wPTA7BgwrBgEE
AbIxAQIBAQEwKzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwgaUG
A1UdHwSBnTCBmjBMoEqgSIZGaHR0cDovL2NybC5jb21vZG9jYS5jb20vVVROLVVTRVJGaXJzdC1D
bGllbnRBdXRoZW50aWNhdGlvbmFuZEVtYWlsLmNybDBKoEigRoZEaHR0cDovL2NybC5jb21vZG8u
bmV0L1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmwwbAYIKwYB
BQUHAQEEYDBeMDYGCCsGAQUFBzAChipodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9VVE5BQUFDbGll
bnRDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAZBgNVHREEEjAQ
gQ5icmFtZXNoQHZ0LmVkdTANBgkqhkiG9w0BAQUFAAOCAQEAQTpK/RfJMVCzOKIhI+VqhXFeAbFx
zVyrzqomWrBHB1/EWXxnKZBCt1hYgutlGarCnHxomphRD9FCmrbvQS7M803iLlfWLb8PGnu9z15Q
jKp+7tbNS7PgJwehr7nfl6IZv9o9M0nCY/CGXdfJUYpEmNgM0ZpIrD6tnhGa+CDOO+rxcMznf/Mi
V+UpL+qIPrRupYY8fnDrLg+HP0ZvXtFyehvGYN1mbqloUx4iDELa999M166iFjxoJsKNodhRvy4/
iCGrkMgfSUI0RBA2whQ0jAQtPcQ1mXZ7QSNxXUN8tHQU5DWodhIPu41MooGPoyjxj51XuiR7r0j/
Pwf+hUasrjGCBLYwggSyAgEBMIHDMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNV
BAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNV
BAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVTRVJGaXJzdC1DbGll
bnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsAhBhw55Iyv5JuhTsTwI1Va6EMAkGBSsOAwIaBQCg
ggLHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTExMDIyNTE4MzAz
MVowIwYJKoZIhvcNAQkEMRYEFL40w8e6d03xKoreo4vxG4/UfjMBMIG3BgkqhkiG9w0BCQ8xgakw
gaYwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjAKBggqhkiG9w0DBzALBglghkgBZQMEAQIwDgYI
KoZIhvcNAwICAgCAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgFAMA0GCCqGSIb3DQMCAgEoMAcGBSsO
AwIaMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgIwCwYJYIZIAWUDBAIBMAoGCCqGSIb3DQIFMIHU
BgkrBgEEAYI3EAQxgcYwgcMwga4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMO
U2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMY
aHR0cDovL3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBB
dXRoZW50aWNhdGlvbiBhbmQgRW1haWwCEGHDnkjK/km6FOxPAjVVroQwgdYGCyqGSIb3DQEJEAIL
MYHGoIHDMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBD
aXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cu
dXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVTRVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRp
b24gYW5kIEVtYWlsAhBhw55Iyv5JuhTsTwI1Va6EMA0GCSqGSIb3DQEBAQUABIIBAARkv7c20n0H
aZKQBczO71wnwfe9K1NE6yxay+NCsflE1ZYgnMxdzHwKJZiXl+ToslT5LQx+C++CvrQMJC9m6S5X
A1KI8euqAGMo7rkpUrkeVbsrUCwu3boLrAB0794hFJtH6fJxCgB7FikM4QwlUH7VvTcGiZLLvghe
9Ym4f18KCAhEhbet/THSOp+nzy39Vs1ov62XuKr9aGyV0Si/eLe8TkiW4gmUCfa8O7OVLEXEsUmi
sPiCuJtIRYHHZIFFhYXd80zvwDHE6cEpqfywliIxmUeM9NbpWlJTwvani9m6Oo6CRTLtYyP9aclJ
wGZMPePSHVcYnQHE4J2Uv/WwF2kAAAAAAAA=

------=_NextPart_000_0149_01CBD4F0.2CAA50F0--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
