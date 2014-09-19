From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: RFC: FMR support in SRP
Date: Fri, 19 Sep 2014 16:04:59 +0200
Message-ID: <541C380B.1000803@acm.org>
References: <CAMGffEkN4OmJVi6UV7PtRYq5q3XZfJVTEaJFqvypx0W8Aq8cRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040501020507020107060202"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffEkN4OmJVi6UV7PtRYq5q3XZfJVTEaJFqvypx0W8Aq8cRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------040501020507020107060202
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/19/14 15:11, Jinpu Wang wrote:
> During go through SRP FMR support, I found ib_srp pre-alloc
> fmr_list/map_page in each request,
> fmr_list are alloced as many as target->cmd_sg_cnt
>
> I add some debug message when run fio test with different settings.
> Result show, state.ndesc and state.nmdesc is 1, state.npages is 0,
> after srp_map_sg,
> my question is : do we really need as many cmd_sg_cnt fmr_list, or I
> miss something,  ndesc and nmdesc could be bigger than 1?

Hello Jack,

The limitations for FMR / FR memory registration are more restrictive 
than those imposed by the SCSI core on S/G-list layout. A few examples:
* Memory registered via FMR must be aligned on an FMR page boundary.
* Memory registered via a single FMR / FR registration must be a 
contiguous virtual memory region.
* The maximum size for a memory region registered via FMR or FR 
(dev->mr_max_size) can be below the maximum size of an S/G-list that can 
be passed by the SCSI core.

Hence the need for multiple memory descriptors. In case you are 
wondering how I tested memory registration involving multiple memory 
descriptors: I wrote a test program that causes the SCSI core to send an 
S/G-list to the SRP initiator that consists of 128 elements with four 
bytes of data. None of these elements are aligned on a page boundary and 
no two S/G-list elements are contiguous in virtual memory. This test 
program causes the SRP initiator to allocate 128 memory descriptors. 
Please note that I/O requests submitted by the attached test program 
will only be accepted by the SRP initiator if the cmd_sg_entries kernel 
module parameter has been set to a value >= 128.

Bart.


--------------040501020507020107060202
Content-Type: text/x-c++src;
 name="discontiguous-io.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="discontiguous-io.cpp"

#include <cassert>
#include <cstring>     // memset()
#include <fcntl.h>     // O_RDONLY
#include <iomanip>
#include <iostream>
#include <linux/fs.h>  // BLKSSZGET
#include <scsi/sg.h>   // sg_io_hdr_t
#include <sys/ioctl.h>
#include <unistd.h>    // open()
#include <vector>

class file_descriptor {
public:
    file_descriptor(int fd = -1)
	: m_fd(fd)
    { }
    ~file_descriptor()
    { if (m_fd >= 0) close(m_fd); }
    operator int() const
    { return m_fd; }

private:
    file_descriptor(const file_descriptor &);
    file_descriptor &operator=(const file_descriptor &);

    int m_fd;
};

class iovec_t {
public:
    iovec_t()
    { }
    ~iovec_t()
    { }
    size_t size() const
    { return m_v.size(); }
    const sg_iovec_t& operator[](const int i) const
    { return m_v[i]; }
    sg_iovec_t& operator[](const int i)
    { return m_v[i]; }
    void append(void *addr, size_t len) {
	m_v.resize(m_v.size() + 1);
	decltype(m_v)::iterator p = m_v.end() - 1;
	p->iov_base = addr;
	p->iov_len = len;
    }
    const void *address() const {
	return &*m_v.begin();
    }
    size_t data_len() const {
	size_t len = 0;
	for (decltype(m_v)::const_iterator p = m_v.begin(); p != m_v.end(); ++p)
	    len += p->iov_len;
	return len;
    }
    void trunc(size_t len) {
	size_t s = 0;
	for (decltype(m_v)::iterator p = m_v.begin(); p != m_v.end(); ++p) {
	    s += p->iov_len;
	    if (s >= len) {
		p->iov_len -= s - len;
		assert(p->iov_len > 0 || (p->iov_len == 0 && len == 0));
		m_v.resize(p - m_v.begin() + 1);
		break;
	    }
	}
    }
    std::ostream& write(std::ostream& os) const {
	for (decltype(m_v)::const_iterator p = m_v.begin(); p != m_v.end(); ++p)
	    os.write((const char *)p->iov_base, p->iov_len);
	return os;
    }

private:
    iovec_t(const iovec_t &);
    iovec_t &operator=(const iovec_t &);

    std::vector<sg_iovec_t> m_v;
};

static unsigned block_size;

static void dumphex(std::ostream &os, const void *a, size_t len)
{
    for (int i = 0; i < len; i += 16) {
	os << std::hex << std::setfill('0') << std::setw(16)
	   << (uintptr_t)a + i << ':';
	for (int j = i; j < i + 16 && j < len; j++) {
	    if (j % 4 == 0)
		os << ' ';
	    os << std::hex << std::setfill('0') << std::setw(2)
	       << (unsigned)((uint8_t*)a)[j];
	}
	os << "  ";
	for (int j = i; j < i + 16 && j < len; j++) {
	    unsigned char c = ((uint8_t*)a)[j];
	    os << (c >= ' ' && c < 128 ? (char)c : '.');
	}
	os << '\n';
    }
}

enum {
    MAX_READ_WRITE_6_LBA = 0x1fffff,
    MAX_READ_WRITE_6_LENGTH = 0xff,
};

static ssize_t sg_read(const file_descriptor &fd, uint32_t lba, const iovec_t &v)
{
    if (lba > MAX_READ_WRITE_6_LBA)
	return -1;

    if (v.data_len() == 0 || (v.data_len() % block_size) != 0)
	return -1;

    if (v.data_len() / block_size > MAX_READ_WRITE_6_LENGTH)
	return -1;

    int sg_version;
    if (ioctl(fd, SG_GET_VERSION_NUM, &sg_version) < 0 || sg_version < 30000)
	return -1;

    uint8_t read6[6] = { 0x08, (uint8_t)(lba >> 16), (uint8_t)(lba >> 8),
			 (uint8_t)(lba), (uint8_t)(v.data_len() / block_size),
			 0 };
    unsigned char sense_buffer[32];
    sg_io_hdr_t h = { .interface_id = 'S' };

    h.cmdp = read6;
    h.cmd_len = sizeof(read6);
    h.dxfer_direction = SG_DXFER_FROM_DEV;
    h.iovec_count = v.size();
    h.dxfer_len = v.data_len();
    h.dxferp = const_cast<void*>(v.address());
    h.sbp = sense_buffer;
    h.mx_sb_len = sizeof(sense_buffer);
    h.timeout = 1000;     /* 1000 millisecs == 1 second */
    if (ioctl(fd, SG_IO, &h) < 0) {
	std::cerr << "READ(6) ioctl failed with errno " << errno << '\n';
        return -1;
    }
    if (h.status) {
	std::cerr << "READ(6) failed with SCSI status " << (unsigned)h.status
		  << "\n";
	if (h.status == 2) {
	    std::cerr << "Sense buffer:\n";
	    dumphex(std::cerr, sense_buffer, h.sb_len_wr);
	}
	return -1;
    }
    return v.data_len() - h.resid;
}

static ssize_t sg_write(const file_descriptor &fd, uint32_t lba, const iovec_t &v)
{
    if (lba > MAX_READ_WRITE_6_LBA)
	return -1;

    if (v.data_len() == 0 || (v.data_len() % block_size) != 0)
	return -1;

    if (v.data_len() / block_size > MAX_READ_WRITE_6_LENGTH)
	return -1;

    int sg_version;
    if (ioctl(fd, SG_GET_VERSION_NUM, &sg_version) < 0 || sg_version < 30000)
	return -1;

    uint8_t write6[6] = { 0x0a, (uint8_t)(lba >> 16), (uint8_t)(lba >> 8),
			  (uint8_t)(lba), (uint8_t)(v.data_len() / block_size),
			  0 };
    unsigned char sense_buffer[32];
    sg_io_hdr_t h = { .interface_id = 'S' };

    h.cmdp = write6;
    h.cmd_len = sizeof(write6);
    h.dxfer_direction = SG_DXFER_TO_DEV;
    h.iovec_count = v.size();
    h.dxfer_len = v.data_len();
    h.dxferp = const_cast<void*>(v.address());
    h.sbp = sense_buffer;
    h.mx_sb_len = sizeof(sense_buffer);
    h.timeout = 1000;     /* 1000 millisecs == 1 second */
    if (ioctl(fd, SG_IO, &h) < 0) {
	std::cerr << "WRITE(6) ioctl failed with errno " << errno << '\n';
        return -1;
    }
    if (h.status) {
	std::cerr << "WRITE(6) failed with SCSI status " << (unsigned)h.status
		  << "\n";
	if (h.status == 2) {
	    std::cerr << "Sense buffer:\n";
	    dumphex(std::cerr, sense_buffer, h.sb_len_wr);
	}
	return -1;
    }
    return v.data_len() - h.resid;
}

static void usage()
{
    std::cout <<
     "Usage: [-h] [-l <length_in_bytes>] [-o <lba_in_bytes>] [-s] [-w] <dev>\n";
}

int main(int argc, char **argv)
{
    bool scattered = false, write = false;
    uint32_t offs = 0;
    const char *dev;
    int c;
    std::vector<uint8_t> buf;
    size_t len = 512;

    while ((c = getopt(argc, argv, "hl:o:sw")) != EOF) {
	switch (c) {
	case 'l': len = strtoul(optarg, NULL, 0); break;
	case 'o': offs = strtoul(optarg, NULL, 0); break;
	case 's': scattered = true; break;
	case 'w': write = true; break;
	default: usage(); goto out;
	}
    }

    if (argc - optind < 1) {
	std::cerr << "Too few arguments.\n";
	goto out;
    }

    dev = argv[optind];
    buf.resize(len);
    {
	file_descriptor fd(open(dev, O_RDONLY));
	if (fd < 0) {
	    std::cerr << "Failed to open " << dev << "\n";
	    goto out;
	}
	if (ioctl(fd, BLKSSZGET, &block_size) < 0) {
	    std::cerr << "Failed to query block size of " << dev << "\n";
	    goto out;
	}
	if (offs % block_size) {
	    std::cerr << "LBA is not a multiple of the block size.\n";
	    goto out;
	}
	iovec_t iov;
	if (scattered) {
	    buf.resize(buf.size() * 2);
	    unsigned char *p = &*buf.begin();
	    for (int i = 0; i < len / 4; i++)
		iov.append(p + 4 + i * 8, std::min(4ul, len - i * 4));
	} else {
	    iov.append(&*buf.begin(), buf.size());
	}
	if (write) {
	    for (int i = 0; i < iov.size(); i++) {
		sg_iovec_t& e = iov[i];
		size_t prevgcount = std::cin.gcount();
		if (!std::cin.read((char *)e.iov_base, e.iov_len)) {
		    e.iov_len = std::cin.gcount() - prevgcount;
		    break;
		}
	    }
	    ssize_t len = sg_write(fd, offs / block_size, iov);
	    if (len >= 0)
		std::cout << "Wrote " << len << "/" << iov.data_len()
			  << " bytes of data.\n";
	} else {
	    ssize_t len = sg_read(fd, offs / block_size, iov);
	    if (len >= 0) {
		std::cerr << "Read " << len << " bytes of data:\n";
		iov.trunc(len);
		iov.write(std::cout);
	    }
	}
    }

out:
    return 0;
}

// Local variables:
// c-basic-offset: 4
// c-label-minimum-indentation: 0
// compile-command: "g++ -g -o discontiguous-io -Wall -Wextra -Werror -Wno-sign-compare -Wno-missing-field-initializers --std=c++11 discontiguous-io.cpp"
// End:

--------------040501020507020107060202--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
