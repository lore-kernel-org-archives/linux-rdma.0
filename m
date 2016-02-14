From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: 4.5-rc iser issues
Date: Sun, 14 Feb 2016 11:59:28 +0200
Message-ID: <56C05000.1040001@dev.mellanox.co.il>
References: <20160214074119.GA24558@infradead.org>
 <56C04294.3090701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040502080405010800030008"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C04294.3090701-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lin-SSI <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------040502080405010800030008
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit


>> The only other kernel version I had available quickly is 3.16 from Debian
>> Jessie, and that works fine.
>
> Thanks for reporting, I'll have a look.
>
> I suspect this is coming from Keith+Ming changes in
> blk_bio_segment_split()...

OK,

I can clearly see that the block layer commitment to respect the
driver virtual boundary was broken in 4.5.

 From the log:
iser: sg[0] dma_addr:0x85FC06000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[1] dma_addr:0x860334000 off:0x0 sz:0x200 dma_len:0x200 <-- gap
iser: sg[2] dma_addr:0x860335000 off:0x0 sz:0x200 dma_len:0x200 <-- gap
iser: sg[3] dma_addr:0x8621EA000 off:0x0 sz:0x200 dma_len:0x200 ...
iser: sg[4] dma_addr:0x8621EB000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[5] dma_addr:0x860384000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[6] dma_addr:0x860385000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[7] dma_addr:0x860316000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[8] dma_addr:0x860317000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[9] dma_addr:0x860294000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[10] dma_addr:0x860295000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[11] dma_addr:0x8609F8000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[12] dma_addr:0x8609F9000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[13] dma_addr:0x8607DA000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[14] dma_addr:0x8607DB000 off:0x0 sz:0x200 dma_len:0x200
iser: sg[15] dma_addr:0x8607D4000 off:0x0 sz:0x200 dma_len:0x200
--

While iser sets the virtual boundary to be 4096, we can
clearly see that each of the SG elements contain a gap
and should not ever see those...

I'm bisecting now, there are a couple of patches from Ming in
the area of the bio splitting code...

CC'ing Ming, Linux-block and Linux-nvme as iser is identical to nvme
wrt the virtual boundary so I think nvme will break as well.

Attaching a small test program I used to force gappy I/O.

$ ./scatter_data -l 64k -n 128 -d <dev>

--------------040502080405010800030008
Content-Type: text/plain; charset=UTF-8;
 name="scattered_data.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scattered_data.c"

/**
 * Scattered IO test
 *
 * Author: Adir Lev
 **/
#define _GNU_SOURCE

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <malloc.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <string.h>
#include <getopt.h>
#include <sys/uio.h>
#include <sys/time.h>
#include <assert.h>


#define MAX_SGE 128

int do_write = 0;
int count = 1;
int num_sge = 0;
int bs = 0;
char *dev;
size_t page_size;
void *ibuf;
void *obuf;
long disk_sz = 0;


double time_diff(struct timeval x , struct timeval y) {
	double x_ms , y_ms , diff;
	x_ms = (double)x.tv_sec*1000000 + (double)x.tv_usec;
	y_ms = (double)y.tv_sec*1000000 + (double)y.tv_usec;
	diff = (double)y_ms - (double)x_ms;
	return diff;
}

void print_usage(char* cmd) {
	printf("USAGE: %s -l 1024 -n 2 -d /dev/sdb [-C 1000]\n", cmd);
	printf("\t-l bs in KBytes\n");
	printf("\t-n num of sges to use\n");
	printf("\t-d block device\n");
	printf("\t[-C] num of iterations\n");
}

int open_block_dev() {
	FILE *fp;
	int fd, rc;
	long sz;

	printf("Device: %s\n", dev);
	fd = open(dev, O_RDWR|O_DIRECT|O_SYNC, 777);
	if (fd < 0) {
		perror("Unable to open block device");
		return fd;
	}

	fp = fdopen(fd, "w+");
	if (!fp) {
		printf("failed to fdopen, errno=%d\n", errno);
		return -1;
	}

	rc = fseek(fp, 0, SEEK_END);
	if (rc < 0) {
		printf("failed to fseek, errno=%d\n", errno);
		return -1;
	}

	disk_sz = ftell(fp);
	if (disk_sz < 0) {
		printf("failed to ftell, errno=%d\n", errno);
		return -1;
	}

	rewind(fp);

	return fd;
}

int my_rewind(fd) {
	FILE *fp;

	fp = fdopen(fd, "w+");
	if (!fp) {
		printf("failed to fdopen, errno=%d\n", errno);
		return -1;
	}
	rewind(fp);
	return 0;
}

int parse_args(int argc, char **argv) {
	int option = 0;

	while ((option = getopt(argc, argv,"wC:l:n:d:")) != -1) {
		switch (option) {
			case 'w':
				do_write = 1;
				break;
			case 'C':
				count = atoi(optarg);
				break;
			case 'd':
				dev = optarg;
				break;
			case 'l':
				bs = atoi(optarg);
				break;
			case 'n':
				num_sge = atoi(optarg);
				break;
			default:
				print_usage(argv[0]);
				return -1;
		}
	}

	/* sanity check args */
	if (optind < 4) {
		printf("Mandatory argument(s) missing\n");
		print_usage(argv[0]);
		return -1;
	}

	if (bs == 512) {
		printf("ERROR: Block size must exceed 512Bytes \n");
		return -1;
	}
	bs = bs * 1024;
	if (num_sge > MAX_SGE) {
		printf("ERROR: num_sge (-n) cannot exceed 128\n");
		return -1;
	}

	if (bs % 512 != 0) {
		printf("ERROR: Block size must be multiple of 512\n");
		return -1;
	}

	if ((bs / num_sge) % 512 != 0) {
		printf("ERROR: Block size/num_sge must be multiple of 512\n");
		return -1;
	}

	if (bs > (page_size * 128)) {
		printf("ERROR: Block size cannot exceed 524288 Bytes (4096B * 128)\n");
		return -1;
	}

	if (count < 1) {
		printf("ERROR: count needs to be higher than 0\n");
		return -1;
	}

	return 0;
}

void* alloc_sges()
{
	void *buf;
	int sge_size = bs / num_sge;

	if (sge_size > page_size) {
		printf("ERROR: sge size cannot exceed page size\n");
		return NULL;
	}

	buf = memalign(page_size, num_sge * page_size);
	if (!buf)
		perror( "ERROR: cannot allocate memory");

	memset(buf, 0, num_sge * page_size);

	return buf;
}

int sample_counter() {
	FILE *fp;
	int val;

	system("iscsiadm -m session -s | grep fmr_un | awk '{print $2}'"
	       " | awk '{ sum+=$1} END {print sum}' >> /tmp/indir_counter");

	fp = fopen("/tmp/indir_counter", "rw");
	if (!fp) {
		perror("Unable to open counter file");
		return -1;
	}

	fscanf(fp, "%d", &val);

	if (val < 0) {
		printf("Failed to get fmr_unaligned counter\n");
		return -1;
	}

	fclose(fp);
	unlink("/tmp/indir_counter");
	return val;
}

void get_stats(struct timeval t_before, struct timeval t_after) {
	double t_diff;
	float iops;
	long bw;

	t_diff = time_diff(t_before, t_after);
	iops = (float)count / t_diff * 1000;
	bw = iops * bs;

	printf("time elapsed in sec %f\n", t_diff/1000000);
	printf("iops: %.2fkiops\n", iops);
	printf("BW: %ldKB\n", bw);
}

int calc_counter(int before, int after) {
	int total = 0;

	total = after - before;
	if (total != count * 2) {
		printf("count: %d, fmr_unaligned_cntr: %d\n", count, total);
		return -1;
	} else {
		return 0;
	}
}

static void dump_bufs(void *s1, void *s2, int len)
{
	int i;

	for (i = 0; i < len; i += 8) {
		uint64_t idword = *(uint64_t *)&(((char *)s2)[i]);
		uint64_t odword = *(uint64_t *)&(((char *)s1)[i]);

		printf("obuf[%x]: %x,		ibuf[%x]: %x\n",
			i, odword, i, idword);
	}
}

static int run_rw(int is_write, int fd, void *buf)
{
	struct iovec iov[num_sge];
	int sge_size = bs / num_sge;
	int max = page_size - sge_size;
	int i = 0, j = 0, offset = 0, rc = 0;
	ssize_t bytes_read;
	long bytes_left = disk_sz;

	/* for every iteration */
	for (i = 0; i < count; i++) {
		if (max > 0)
			offset = (512 * i) % max;
		if (bytes_left < bs) {
			rc = my_rewind(fd);
			if (rc < 0)
				return rc;
			printf("count: %d, no space left on block "
			       "device, rewinding\n", i);
			bytes_left = disk_sz;
		}
		/* for every sge */
		for (j = 0; j < num_sge; j++) {
			/* change offset in page */
			iov[j].iov_base = buf + (page_size * j) + offset;
			iov[j].iov_len = sge_size;
			if (is_write)
				memset(iov[j].iov_base, i+j, iov[j].iov_len);
		}

		if (is_write) {
			bytes_read = writev(fd, iov, num_sge);
			if (bytes_read < bs) {
				if (bytes_read < 0) {
					printf("failed to writev, bytes=%d, "
						"errno=%d\n", bytes_read, errno);
					perror("failed to writev");
				} else
					printf("writev less than expected. "
						"Bytes=%d, expected %d\n", bytes_read, bs);
				return -1;
			}
		} else {
			bytes_read = readv(fd, iov, num_sge);
			if (bytes_read < bs) {
				if (bytes_read < 0) {
					printf("failed to readv, bytes=%d, "
						"errno=%d\n", bytes_read, errno);
					perror("failed to readv");
				} else
					printf("readv less than expected. "
						"Bytes=%d, expected %d\n", bytes_read, bs);
				return -1;
			}
		}
		bytes_left -= bs;
	}

	return 0;
}

int run_iovec_traffic(int fd)
{
	int rc;

	rc = my_rewind(fd);
	if (rc) {
		printf("rewind failed\n");
		return -1;
	}

	rc = run_rw(1, fd, obuf);
	if (rc) {
		printf("write failed\n");
		return -1;
	}

	rc = my_rewind(fd);
	if (rc) {
		printf("rewind failed\n");
		return -1;
	}

	rc = run_rw(0, fd, ibuf);
	if (rc) {
		printf("read failed\n");
		return -1;
	}

	rc = memcmp(ibuf, obuf, bs);
	if (rc) {
		printf("memcmp failed\n");
		dump_bufs(obuf, ibuf, bs);
		return -1;
	}

	return rc;
}

int main(int argc, char **argv) {
	struct timeval t_before, t_after;
	void **page_list = NULL;
	int fd, before_counter = 0, after_counter = 0, rc = 0;

	page_size = sysconf(_SC_PAGESIZE);
	rc = parse_args(argc, argv);
	if (rc)
		return -1;

	fd = open_block_dev();
	if (fd < 0)
		return -1;

	ibuf = alloc_sges();
	if (!ibuf) {
		rc = -ENOMEM;
		goto out;
	}

	obuf = alloc_sges();
	if (!obuf) {
		rc = -ENOMEM;
		goto out;
	}

	before_counter = sample_counter();
	if (before_counter < 0) {
		rc = -1;
		goto out;
	}

	gettimeofday(&t_before, NULL);
	rc = run_iovec_traffic(fd);
	gettimeofday(&t_after, NULL);

	if (rc) {
		printf("Exiting with rc=%d\n", rc);
		goto out;
	}

	get_stats(t_before, t_after);

	after_counter = sample_counter();
	if (after_counter < 0) {
		rc = -1;
		goto out;
	}

	rc = calc_counter(before_counter, after_counter);
	if (rc) {
		printf("Test Failed unaligned count\n");
		goto out;
	}

	printf("Test Passes\n");
out:
	close(fd);
	free (ibuf);
	free (obuf);

	return rc;
}

--------------040502080405010800030008--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
